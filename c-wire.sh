#!/bin/bash
# On vérifie si l'option -h est passée en argument
for arg in "$@"; do
    if [ "$arg" == "-h" ]; then
        if [ -f "aide.txt" ]; then
            cat aide.txt    # Permet d'affichier le contenu de l'aide
            exit 1
        fi
    fi
done

# On vérifie que le nombre d'argument est correct
if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    echo "ERREUR. Le nombre d'arguments passé en paramètres est incorrect."
    echo "Temps de traitement: 0.0 secondes"
    cat aide.txt
    exit 1
fi

#Initialisation des variables.
fichier=$1
station=$2
consommateur=$3

# Si le nombre d'arguments est 4, on définit "centrale" comme le dernier argument
if [ $# -eq 4 ]; then
    centrale=$4
    if [[ -n "$centrale" ]] && [[ ! "$centrale" =~ ^[1-9][0-9]*$ ]]; then
        echo "ERREUR. Le numéro de la centrale passé en paramètres est incorrect."
        echo "Temps de traitement: 0.0 secondes"
        cat aide.txt
        exit 1
    fi
fi

# Vérification de l'existence du fichier CSV
if [ ! -f "$fichier" ]; then
    echo "Erreur : Le fichier passé en paramètres n'existe pas."
    echo "Temps de traitement: 0.0 secondes"
    cat aide.txt
    exit 1
fi


# Vérification du type de la station
if [[ "$station" != "hvb" ]] && [[ "$station" != "hva" ]] && [[ "$station" != "lv" ]]; then
    echo "Erreur : Le deuxieme argument doit être 'hva', 'hvb', ou 'lv'."
    echo "Temps de traitement: 0.0 secondes"
    cat aide.txt
    exit 1
fi


# Vérification du type de consommateur
if [[ "$consommateur" != "comp" ]] && [[ "$consommateur" != "indiv" ]] && [[ "$consommateur" != "all" ]]; then
    echo "Erreur : Le troisieme argument doit être 'comp', 'indiv', ou 'all'."
    echo "Temps de traitement: 0.0 secondes"
    cat aide.txt
    exit 1
fi


# On créer, si besoin, le fichier 'tmp'
if [[ ! -d "tmp" ]]; then
    mkdir "tmp"
else
    rm "tmp"/*
fi

#Initialisation du temps d'éxécution
debut=$(date +%s)


# Vérification de la combinaison de station et conso et filtrage des données
echo "Filtrage des données en cours..."
touch "tmp/fichier_filtre.csv"

case "$station $consommateur" in
    'hva indiv' | 'hva all')
        echo "Erreur : '$station $consommateur' n'est pas une combinaison valide. Essayez 'hva comp'."
        echo "Temps de traitement: 0.0 secondes"
            exit 1
        ;;
        'hvb indiv' | 'hvb all')
            echo "Erreur : '$station $consommateur' n'est pas une combinaison valide. Essayez 'hvb comp'."
            echo "Temps de traitement: 0.0 secondes"
            exit 1
        ;;
        'hvb comp')
            if [ -n "$centrale" ]; then
                    grep -E "^$centrale;[0-9]+;-;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 2,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
                    
            else
                    grep -E "^[0-9]+;[0-9]+;-;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 2,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            fi
        ;;
        'hva comp')
            if [ -n "$centrale" ]; then
                    grep -E "^$centrale;[^;]+;[0-9]+;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 3,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            else
                    grep -E "^[0-9]+;[^;]+;[0-9]+;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 3,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            fi
        ;;
        'lv comp')
            if [ -n "$centrale" ]; then
                    grep -E "^$centrale;-;[^;]+;[0-9]+;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            else
                    grep -E "^[0-9]+;-;[^;]+;[0-9]+;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            fi
        ;;
        'lv indiv')
            if [ -n "$centrale" ]; then
                    grep -E "^$centrale;-;[^;]+;[0-9]+;-;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            else
                    grep -E "^[0-9]+;-;[^;]+;[0-9]+;-;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            fi
        ;;
        'lv all')
            if [ -n "$centrale" ]; then
                    grep -E "^$centrale;-;[^;]+;[0-9]+;[^;]+;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            else
                    grep -E "^[0-9]+;-;[^;]+;[0-9]+;[^;]+;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/fichier_filtre.csv"
            fi
        ;;
        *)
            echo "Erreur : combinaison station/consommateur invalide."
            cat aide.txt
           echo "Temps de traitement: 0.0 secondes"
        exit 1
        ;;
        
esac

echo "Filtrage terminé"
fin_filtrage=$(date +%s)
temps_filtrage=$((fin_filtrage - debut))

cd codeC
make clean 
make all

if [ $? -eq 0 ]; then
    echo "Compilation réussie"
else
    echo "La compilation a échoué"
    exit 1
fi
cd ..

# On vérifie que l'éxécutable existe bien
if [ ! -f "codeC/exec.exe" ]; then
    echo "ERREUR. L'executable n'existe pas."
    echo "Temps de traitement: 0.0 secondes"
    exit 1
fi

if [[ ! -d "test" ]]; then
    mkdir "test"
fi

./codeC/exec.exe "tmp/fichier_filtre.csv" "$station" "$consommateur"

if [ $? -ne 0 ]; then
    echo "ERREUR. L'exécution du programme a échoué."
    echo "Temps de traitement: 0.0 secondes"
    exit 1
fi

if [[ -s "tmp/resultat.csv" ]]; then
    if [[ -n "$centrale" ]]; then
        # Cas du lv all
        if [[ "$station" == "lv" ]] && [[ "$consommateur" == "all" ]]; then
            echo "$station:Capacité:Consommation:Difference capacité/consommation" >"test/${station}_${consommateur}_${centrale}.csv"
            while IFS=: read -r station capacite consommation; do
                if [[ "$station" != "Station" ]]; then
                    diff=$((capacite - consommation))
                    abs_diff=$((diff < 0 ? -diff : diff))
                    echo "$station:$capacite:$consommation:$abs_diff"
                fi
            done < "tmp/resultat.csv" | sort -t: -k4 -n >> "test/${station}_${consommateur}_${centrale}.csv"
            head -n 11 "test/${station}_${consommateur}_${centrale}.csv" > "test/lv_all_minmax.csv" #on recupère les 10 premières lignes de données + l'en-tête
            tail -n 10 "test/${station}_${consommateur}_${centrale}.csv" >> "test/lv_all_minmax.csv"
            echo "Le fichier final \"lv_all_minmax.csv\" est prêt dans le dossier \"test\""
        else
            echo "$station:Capacité:Consommation" >"test/${station}_${consommateur}_${centrale}.csv"
            sort -t: -k2 -n "tmp/resultat.csv" >> "test/${station}_${consommateur}_${centrale}.csv"
            echo "Le fichier final \"${station}_${consommateur}_${centrale}.csv\" est prêt dans le dossier \"test\""
        fi
    else
        # Cas du lv all
        if [[ "$station" == "lv" ]] && [[ "$consommateur" == "all" ]]; then
            echo "$station:Capacité:Consommation:Difference capacité/consommation" >"test/${station}_${consommateur}.csv"
            while IFS=: read -r station capacite consommation; do
                if [[ "$station" != "Station" ]]; then
                    diff=$((capacite - consommation))
                    abs_diff=$((diff < 0 ? -diff : diff))
                    echo "$station:$capacite:$consommation:$abs_diff"
                fi
            done < "tmp/resultat.csv" | sort -t: -k4 -n >> "test/${station}_${consommateur}.csv"
            head -n 11 "test/${station}_${consommateur}.csv" > "test/lv_all_minmax.csv"#on recupère les 10 premières lignes de données + l'en-tête
            tail -n 10 "test/${station}_${consommateur}.csv" >> "test/lv_all_minmax.csv"
            echo "Le fichier final \"lv_all_minmax.csv\" est prêt dans le dossier \"test\""
        else
            echo "$station:Capacité:Consommation" >"test/${station}_${consommateur}.csv"
            sort -t: -k2 -n "tmp/resultat.csv" >> "test/${station}_${consommateur}.csv"
            echo "Le fichier final \"${station}_${consommateur}.csv\" est prêt dans le dossier \"test\""
        fi
    fi
fi

# Arret du temps
fin_total=$(date +%s)
temps_total=$((fin_total - debut))
echo "Temps de filtrage: ${temps_filtrage} secondes"
echo "Temps de traitement total: ${temps_total} secondes"  
