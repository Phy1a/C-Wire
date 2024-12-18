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
        cat aide.txt
        exit 1
    fi
fi

# On vérifie que le chemin du fichier est correct
if [ ! -f "$fichier" ]; then
    echo "ERREUR. Le chemin du fichier passé en paramètres est incorrect."
    cat aide.txt
    exit 1
fi

# Vérification de l'existence du fichier CSV
if [ ! -f "$fichier" ]; then
    echo "Erreur : Le fichier passé en paramètres n'existe pas."
    cat aide.txt
    exit 1
fi


# Vérification du type de la station
if [[ "$station" != "hvb" ]] && [[ "$station" != "hva" ]] && [[ "$station" != "lv" ]]; then
    echo "Erreur : Le deuxieme argument doit être 'hva', 'hvb', ou 'lv'."
    cat aide.txt
    exit 1
fi


# Vérification du type de consomation
if [[ "$consommateur" != "comp" ]] && [[ "$consommateur" != "indiv" ]] && [[ "$consommateur" != "all" ]]; then
    echo "Erreur : Le troisieme argument doit être 'comp', 'indiv', ou 'all'."
    cat aide.txt
    exit 1
fi

# On créer, si besoin, le fichier 'tmp'
if [[ ! -d "tmp" ]]; then
    mkdir tmp
else
    rm tmp/*
fi

# Compilation du programme C
make clean && make

if [ $? -ne 0 ]; then
    echo "La compilation a échoué"
    exit 1
fi

#Initialisation du temps d'éxécution
debut=$(date +%s)

# Vérification de la combinaison de station et conso et filtrage des données
echo "Filtrage des données en cours..."
case "$station $consommateur" in
    'hva indiv' | 'hva all')
        echo "Erreur : '$station $consommateur' n'est pas une combinaison valide. Essayez 'hva comp'."
            exit 1
        ;;
        'hvb indiv' | 'hvb all')
            echo "Erreur : '$station $consommateur' n'est pas une combinaison valide. Essayez 'hvb comp'."
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
        exit 1
        ;;
        
esac

# Arret du temps
fin=$(date +%s)
temps=$((fin - debut))
echo "Filtrâge terminé"
echo "Temps de traitement: ${temps} secondes"  

# On vérifie que l'éxécutable existe bien
if [ ! -f "exec.exe" ]; then
    echo "ERREUR. L'executable n'existe pas."
    exit 1
fi

"./exec" "tmp/fichier_filtre.csv" > sortie_c.csv
# voir 2>resultat.log

if [ $? -ne 0 ]; then
    echo "ERREUR. L'exécution du programme a échoué."
    exit 1
fi

if [[ -s "sortie_c.csv" ]]; then
    if [ -n "$centrale" ]; then
        sort -t: -k2 -n "sortie_c.csv" > "${station}_${consommateur}_${centrale}.csv"
    else
        sort -t: -k2 -n "sortie_c.csv" > "${station}_${consommateur}.csv"
    fi
    # Cas du lv all
    if [[ "$station" == "lv" ]] && [[ "$consommateur" == "all" ]]; then
        head -n 10 sortie_c.csv > lv_all_minmax.csv
        tail -n 10 sortie_c.csv >> lv_all_minmax.csv
    fi
fi

