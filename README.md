# C-Wire

## Table des matières

- [Objectif](#Objectif)

- [Guide d'utilisation](#Guide-d'utilisation)

- [Options possibles](#Options-possibles)

- [Exemple d'utilisation](#Exemple-d'utilisation)

- [Arborescence du projet](#Arborescence-du-projet)

- [Auteur](#Auteur)

## Objectif

L'objectif est d'analyser les données des stations afin de déterminer si elles sont en situation de surproduction ou de sous production. Pour cela, l'utilisateur doit indiquer en paramètres le type de station et de consommateurs qu'il souhaite examiner. Il peut aussi indiquer une centrale pour affiner ces recherches.

[Projet](
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

## Options possibles

- hvb comp
- hva comp
- lv indiv
- lv comp
- lv all

Si vous souhaitez afficher une aide, indiquez en paramètres `-h`.

## Exemple d'utilisation

```bash
#Traitement des hvb comp de toutes les centrales
./c-wire.sh input/c-wire_v25.dat hvb comp

#Traitement des hva comp de la centrale 4
./c-wire.sh input/c-wire_v25.dat hva comp 4

```

## Arborescence du projet

```bash
C-Wire/
├── c-wire.sh              # Script shell principal
├── aide.txt               # Texte d'aide 
├── codeC/                 # Code source C
│   ├── makefile           # Fichier Makefile pour la compilation
│   ├── avl.c              # Implémentation de l'arbre AVL
│   ├── avl.h              # Déclaration des fonctions et structures AVL
│   └── main.c             # Programme principal
├── imput/                 # Données d'entrée
│   ├── c-wire_v00.csv     # Fichier de données 
│   └── input/             # Fichiers d'entrée supplémentaires
├── output/                # Résultats de sortie générés à l'exécution
│   └── hvb_comp_2.csv     # Exemple de fichier de sortie
├── test/                  # Résultats finaux précédents
├── tmp/                   # Fichiers temporaires
└── Rapport                # Compte rendu sur l'organisation de l'équipe et les difficultés rencontrées

```
## Auteur

ASTIER Célia

GRIMALDI Raphaelle

KHODJA Laiza
