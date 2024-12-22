# C-Wire

## Objectif

L'objectif est d'analyser les données des stations afin de déterminer si elles sont en situation de surproduction ou de sousproduction. Pour cela, l'utilisateur doit indiquer en paramètres le type de station et de consommateurs qu'il souhaite examiner. Il peut aussi indiquer une centrale pour affiner ces recherches.

## Guide d'utilisation

```bash
#Cloner le dépot
git clone https://github.com/Phy1a/C-Wire.git

#Accéder au répertoire
cd C-Wire

#Ajouter les droits d'exécution au script shell
chmod +x c-wire.sh

#Avant de commencer : mettre le fichier de données à traiter dans le dossier "input"
mv <chemin du fichier à traiter> input

#Commande à écrire dans le terminal :
./c-wire.sh <chamin du fichier de données> <type de station> <type de consommateur> <numéro de centrale si besoin>
#ou
bash c-wire.sh <chemin du fichier de données> <type de station> <type de consommateur> <numéro de centrale si besoin>

```

## Exemple d'utilisation

```bash
#Traitement des hvb comp de toutes les centrales
./c-wire.sh input/c-wire_v25.dat hvb comp

#Traitement des hva comp de la centrale 4
./c-wire.sh input/c-wire_v25.dat hva comp 4

```

## Arborescence du projet

## Auteur

ASTIER Célia

GRIMALDI Raphaelle

KHODJA Laiza
