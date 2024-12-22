# C-Wire

## Objectif

L'objectif est d'analyser les données des stations afin de déterminer si elles sont en situation de surproduction ou de sousproduction. Pour cela, l'utilisateur doit indiquer en paramètres le type de station et de consommateurs qu'il souhaite examiner. Il peut aussi indiquer une centrale pour affiner ces recherches.

## Guide d'utilisation

```bash
#Cloner le dépot
git clone https://github.com/Phy1a/C-Wire.git

#Accéder au répertoire
cd C-Wire

#Avant de commencer : mettre le fichier de données à traiter dans le dossier "data"
mv <chemin du fichier à traiter> data

#Commande à écrire dans le terminal :
./c-wire.sh <chamin du fichier de données> <type de station> <type de consommateur> <numéro de centrale si besoin>
#ou
bash c-wire.sh <chemin du fichier de données> <type de station> <type de consommateur> <numéro de centrale si besoin>

```

## Auteur

ASTIER Célia

GRIMALDI Raphaelle

KHODJA Laiza
