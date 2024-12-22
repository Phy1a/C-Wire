#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "traitement.h"
#include "avl.h"

void ecrire(AVL* a, FILE* fichier){  // fonction pour écrire les données d'un arbre dans un fichier
    if(a!=NULL){
        ecrire(a->fg, fichier);  // appel récursif pour parcourir le sous-arbre gauche
        fprintf(fichier, "%d:%ld:%ld\n", a->station.identifiant, a->station.capacite, a->station.conso);  // écrit les informations du nœud courant dans le fichier
        ecrire(a->fd, fichier);
        free(a);  // libère la mémoire allouée pour le nœud courant
    }
}

AVL* recupererFichier(FILE* fichier){  // fonction pour construire un arbre AVL à partir d'un fichier
    int id;
    long capacite;
    long consommation;
    int h = 0;
    AVL* a = NULL;
    while(fscanf(fichier, "%d;%ld;%ld", &id, &capacite, &consommation) != EOF){  // lit une ligne du fichier jusqu'à la fin (EOF)
        if(consommation == 0){  // si la consommation est 0, on a une nouvelle station
            a = insertAVL(a, id, capacite, &h);
        }
        else{
            a = majConso(a, consommation, id);
        }
    }
    return a;
}

void traitementTotal(FILE* fichier_tmp, FILE* fichier_final){  // fonction pour traiter un fichier et écrire le résultat dans un fichier final
    AVL* a = NULL;
    a = recupererFichier(fichier_tmp);  // construit l'arbre à partir du fichier temporaire
    ecrire(a, fichier_final);  // écrit les données de l'arbre dans le fichier final
}
