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

fichier=$1
station=$2
consommateur=$3

if [ $# -eq 4 ]; then
    centrale=$4
fi

if [ "$station" != "hvb" ] && [ "$station" != "hva" ] && [ "$station" != "lv" ]; then
    echo "ERREUR. Le type de station passé en paramètres est incorrect."
    cat aide.txt
    exit 1
fi

if [ "$station" != "hvb" ] && [ "$station" != "hva" ] && [ "$station" != "lv" ]; then
    echo "ERREUR. Le type de station passé en paramètres est incorrect."
    cat aide.txt
    exit 1
fi


if [ -n "$centrale" ] && [ ! "$centrale" =~ ^[1-5]$ ]; then
    echo "ERREUR. Le numéro de la centrale passé en paramètres est incorrect."
    cat aide.txt
    exit 1
fi

case "$station $conso" in
    'hva indiv' | 'hva all')
        echo "ERREUR. La combinaison de station et de consommateurs passé en paramètres est incorrect."
        cat aide.txt
        exit 1
        ;;
    'hvb indiv' | 'hvb all')
        echo "ERREUR. La combinaison de station et de consommateurs passé en paramètres est incorrect."
        cat aide.txt
        exit 1
        ;;
esac

if [ ! -f "$fichier" ]; then
    echo "ERREUR. Le chemin du fichier passé en paramètres est incorrect."
    cat aide.txt
    exit 1
fi
