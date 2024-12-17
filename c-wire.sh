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
    if [[ -n "$centrale" ]] && [[ ! "$centrale" =~ ^[1-5]$ ]]; then
        echo "ERREUR. Le numéro de la centrale passé en paramètres est incorrect."
        cat aide.txt
        exit 1
    fi
else
    centrale="[1-9][0-9]*" # si la centrale n'est pas spécifiée, on prend toutes les centrales
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

#Initialisation du temps d'éxécution
debut=$(date +%s)

# Vérification de la combinaison de station et conso et filtrage des données
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
                    # Si une centrale est spécifiée, l'ajouter au nom du fichier
                    output_file="${station}_${consommateur}_${centrale}.csv"
                    grep -E "^$centrale;[0-9]+;-;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 2,7,8 | tr '-' '0' > "tmp/$output_file"
                    
            else
                    # Sinon, ne pas ajouter de numéro de centrale
                    output_file="${station}_${consommateur}.csv"
                    grep -E "^[0-9]+;[0-9]+;-;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 2,7,8 | tr '-' '0' > "tmp/$output_file"
            fi
        ;;
        'hva comp')
            if [ -n "$centrale" ]; then
                    # Si une centrale est spécifiée, l'ajouter au nom du fichier
                    output_file="${station}_${consommateur}_${centrale}.csv"
                    grep -E "^$centrale;-;[0-9]+;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 3,7,8 | tr '-' '0' > "tmp/$output_file"
            else
                    # Sinon, ne pas ajouter de numéro de centrale
                    output_file="${station}_${consommateur}.csv"
                    grep -E "^[0-9]+;-;[0-9]+;-;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 3,7,8 | tr '-' '0' > "tmp/$output_file"
            fi
        ;;
        'lv comp')
            if [ -n "$centrale" ]; then
                    # Si une centrale est spécifiée, l'ajouter au nom du fichier
                    output_file="${station}_${consommateur}_${centrale}.csv"
                    grep -E "^$centrale;-;[^;]+;[0-9]+;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
            else
                    # Sinon, ne pas ajouter de numéro de centrale
                    output_file="${station}_${consommateur}.csv"
                    grep -E "^[0-9]+;-;[^;]+;[0-9]+;[^;]+;-;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
            fi
        ;;
        'lv indiv')
            if [ -n "$centrale" ]; then
                    # Si une centrale est spécifiée, l'ajouter au nom du fichier
                    output_file="${station}_${consommateur}_${centrale}.csv"
                    grep -E "^$centrale;-;[^;]+;[0-9]+;-;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
            else
                    # Sinon, ne pas ajouter de numéro de centrale
                    output_file="${station}_${consommateur}.csv"
                    grep -E "^[0-9]+;-;[^;]+;[0-9]+;-;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
            fi
        ;;
        'lv all')
            if [ -n "$centrale" ]; then
                    # Si une centrale est spécifiée, l'ajouter au nom du fichier
                    output_file="${station}_${consommateur}_${centrale}.csv"
                    grep -E "^$centrale;-;[^;]+;[0-9]+;[^;]+;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
            else
                    # Sinon, ne pas ajouter de numéro de centrale
                    output_file="${station}_${consommateur}.csv"
                    grep -E "^[0-9]+;-;[^;]+;[0-9]+;[^;]+;[^;]+;[^;]+;[^;]+" "$fichier" | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
            fi
        ;;
        *)
            echo "Erreur : combinaison station/consommateur invalide."
        exit 1 #voir si utile
        ;;
        
esac

# progc (tri)

#arret du temps
fin=$(date +%s)
temps=$((fin - debut))
echo "Temps de traitement: ${temps} secondes"  


