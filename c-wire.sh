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

#Vérification si tmp existe si oui le suprimer et le creer
if [ -d "tmp" ]; then
    rm -rf "tmp"
fi
mkdir "tmp"


#Initialisation des variables.
fichier=$1
station=$2
consommateur=$3

# Si le nombre d'arguments est 4, on définit "centrale" comme le dernier argument
if [ $# -eq 4 ]; then
    centrale=$4
    if ! [ -n "$centrale" ] || [ "$centrale" -le 0 ]; then
    	echo "Erreur : Le quatrième argument (centrale) doit être un entier positif."
        exit 1
    fi
else
    centrale="[1-9][0-9]*"
fi

# Vérification de l'existence du fichier CSV
if [ ! -f "$fichier_csv" ]; then
    echo "Erreur : Le fichier '$fichier_csv' n'existe pas."
    exit 1
fi


# Vérification du type de la station
if [[ "$station" != "hva" && "$station" != "hvb" && "$station" != "lv" ]]; then
    echo "Erreur : Le deuxieme argument doit être 'hva', 'hvb', ou 'lv'."
    exit 1
fi


# Vérification du type de consomation
if [[ "$conso" != "comp" && "$conso" != "indiv" && "$conso" != "all" ]]; then
    echo "Erreur : Le troisieme argument doit être 'comp', 'indiv', ou 'all'."
    exit 1
fi


#Initialisation du temps d'éxécution
debut=$(date +%s)

# Vérification de la combinaison de station et conso et filtrage des données
case "$station $conso" in
	"hva indiv" | "hva all")
		echo "Erreur : '$station $conso' n'est pas une combinaison valide. Essayez 'hva comp'."
        	exit 1
        ;;
        "hvb indiv" | "hvb all")
        	echo "Erreur : '$station $conso' n'est pas une combinaison valide. Essayez 'hvb comp'."
        	exit 1
        ;;
        "hvb comp")
        	if [[ -n "$centrale" ]]; then
            		# Si une centrale est spécifiée, l'ajouter au nom du fichier
            		output_file="${station}_${conso}_${centrale}.csv"
        	else
            		# Sinon, ne pas ajouter de numéro de centrale
            		output_file="${station}_${conso}.csv"
        	fi
        	grep -E "^$centrale;[0-9]+;-;-;[^;]+;-;[^;]+;[^;]+" c-wire_v00.dat | cut -d ';' -f 2,7,8 | tr '-' '0' > "tmp/$output_file"  
        ;;
        "hva comp")
        	if [[ -n "$centrale" ]]; then
            		# Si une centrale est spécifiée, l'ajouter au nom du fichier
            		output_file="${station}_${conso}_${centrale}.csv"
        	else
            		# Sinon, ne pas ajouter de numéro de centrale
            		output_file="${station}_${conso}.csv"
        	fi
        	grep -E "^$centrale;-;[0-9]+;-;[^;]+;-;[^;]+;[^;]+" c-wire_v00.dat | cut -d ';' -f 3,7,8 | tr '-' '0' > "tmp/$output_file"  
        ;;
        "lv comp")
        	if [[ -n "$centrale" ]]; then
            		# Si une centrale est spécifiée, l'ajouter au nom du fichier
            		output_file="${station}_${conso}_${centrale}.csv"
        	else
            		# Sinon, ne pas ajouter de numéro de centrale
            		output_file="${station}_${conso}.csv"
        	fi
        	grep -E "^$centrale;-;[^;]+;[0-9]+;[^;]+;-;[^;]+;[^;]+" c-wire_v00.dat | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
        ;;
        "lv indiv")
        	if [[ -n "$centrale" ]]; then
            		# Si une centrale est spécifiée, l'ajouter au nom du fichier
            		output_file="${station}_${conso}_${centrale}.csv"
        	else
            		# Sinon, ne pas ajouter de numéro de centrale
            		output_file="${station}_${conso}.csv"
        	fi
        	grep -E "^$centrale;-;[^;]+;[0-9]+;-;[^;]+;[^;]+;[^;]+" c-wire_v00.dat | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"
        ;;
        "lv all")
        	if [[ -n "$centrale" ]]; then
            		# Si une centrale est spécifiée, l'ajouter au nom du fichier
            		output_file="${station}_${conso}_${centrale}.csv"
        	else
            		# Sinon, ne pas ajouter de numéro de centrale
            		output_file="${station}_${conso}.csv"
        	fi
        	grep -E "^$centrale;-;[^;]+;[0-9]+;[^;]+;[^;]+;[^;]+;[^;]+" c-wire_v00.dat | cut -d ';' -f 4,7,8 | tr '-' '0' > "tmp/$output_file"  
        ;;
        *)
        	echo "Erreur : combinaison station/conso invalide."
		exit 1
		;;
        
esac

# progc (tri)

#arret du temps
fin=$(date +%s)
temps=$((fin - debut))
echo "$temps"  
#fin

