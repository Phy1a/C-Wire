#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "avl.h"

AVL* creerAVL(int id, long capa){
    AVL* a = malloc(sizeof(AVL));
    if(a == NULL){
        printf("Erreur lors de l'allocation mémoire");
        exit(1);
    }
    a->fd =NULL;
    a->fg = NULL;
    a->station.identifiant = id;
    a->station.capacite = capa;
    a->station.conso = 0;
    a->equilibre = 0;
    return a;
 }
int min(int a, int b){
    if(a > b){
        return b;
    }
    return a;
}

int max(int a, int b){
    if(a > b){
        return a;
    }
    return b;
}

void liberer(AVL* a){
    if (a != NULL){
       liberer(a->fg);
       liberer(a->fd);
       free(a);
    }
}

AVL* rotationDroite(AVL* a){
    if(a == NULL){
        exit(2);
    }
    AVL* pivot = a->fg;
    a->fg = pivot->fd;
    pivot->fd = a;
    int equ_a = a->equilibre;
    int equ_p = pivot->equilibre;
    a->equilibre = equ_a - min(equ_p, 0) + 1;
    pivot->equilibre = max(max(equ_a+2, equ_a + equ_p +2), equ_p +1);
    a = pivot;
    return a;
}

AVL* rotationGauche(AVL* a){
    if(a == NULL){
        exit(3);
    }
    AVL* pivot = a->fd;
    a->fd = pivot->fg;
    pivot->fg = a;
    int equ_a = a->equilibre;
    int equ_p = pivot->equilibre;
    a->equilibre = equ_a - max(equ_p, 0) -1;
    pivot->equilibre = min(min(equ_a-2, equ_a + equ_p -2), equ_p-1);
    a = pivot;
    return a;
}

AVL* doubleRotationDroite(AVL* a){
    if(a == NULL){
        exit(4);
    }
    a->fg = rotationGauche(a->fg);
    return rotationDroite(a);
}

AVL* doubleRotationGauche(AVL* a){
    if(a == NULL){
        exit(5);
    }
    a->fd = rotationDroite(a->fd);
    return rotationGauche(a);
}

AVL* equilibrerAVL(AVL* a){
    if(a == NULL){
        exit(6);
    }
    if(a->equilibre >= 2){
        if(a->fd->equilibre>=0){
            return rotationGauche(a);
        }
        else{
            return doubleRotationGauche(a);
        }
    }
    else if(a->equilibre<=-2){
        if(a->fg->equilibre<=0){
            return rotationDroite(a);
        }
        else{
            return doubleRotationDroite(a);
        }
    }
    return a;
}

AVL* insertAVL(AVL* a, int id, long capa, int* h){
    if(a == NULL){
        *h = 1;
        return creerAVL(id, capa);
    }
    else if(id < a->station.identifiant){
        a->fg = insertAVL(a->fg, id, capa, h);
        *h = -*h;
    }
    else if(id > a->station.identifiant){
        a->fd = insertAVL(a->fd, id, capa, h);
    }
    else{
        *h = 0;
        return a;
    }
    if(*h!=0){
        a->equilibre = a->equilibre + *h;
        a = equilibrerAVL(a);
        if(a->equilibre==0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    return a;
}

AVL* majConso(AVL* a, long consommation, int id_noeud){  // fonction pour ajouter consommation à un noeud dans l'arbre
    if(a == NULL){
        fprintf(stderr, "Erreur : le nœud avec l'identifiant %d est introuvable dans l'arbre.\n", id_noeud);
        exit(7);
    }
    else if(id_noeud < a->station.identifiant){
        a->fg = majConso(a->fg, consommation, id_noeud);
    }
    else if(id_noeud > a->station.identifiant){
        a->fd = majConso(a->fd, consommation, id_noeud);
    }
    else{
        a->station.conso += consommation;  // met à jour la consommation totale de la station
    }
    return a;
}

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
        if(consommation == 0)  // si la consommation est 0, on a une nouvelle station
            a = insertAVL(a, id, capacite, &h);
        else
            a = majConso(a, consommation, id);
    }
    return a;
}

void traitementTotal(FILE* fichier_tmp, FILE* fichier_final){  // fonction pour traiter un fichier et écrire le résultat dans un fichier final
    AVL* a = NULL;
    a = recupererFichier(fichier_tmp);  // construit l'arbre à partir du fichier temporaire
    ecrire(a, fichier_final);  // écrit les données de l'arbre dans le fichier final
}