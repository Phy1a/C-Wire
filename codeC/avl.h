#ifndef ALV_H
#define ALV_H


typedef struct station{  // définition de la structure représentant une station
    int identifiant;  // identifiant de la station
    long capacite;  // capacite de la station
    long conso;  // somme des consommations associées à cette station
}Station;

typedef struct arbre{  // définition de la structure d'un nœud d'arbre AVL
    Station station;  // données de la station associée à ce nœud
    struct arbre* fd;  // pointeur vers le fils droit
    struct arbre* fg;  // pointeur vers le fils gauche
    int equilibre;  // equilibre arbre
}AVL;

AVL* creerAVL(int id, long capa);
int min(int a, int b);
int max(int a, int b);
void liberer(AVL* a);
AVL* rotationDroite(AVL* a);
AVL* rotationGauche(AVL* a);
AVL* doubleRotationDroite(AVL* a);
AVL* doubleRotationGauche(AVL* a);
AVL* equilibrerAVL(AVL* a);
AVL* insertAVL(AVL* a, int id, long capa, int* h);
AVL* majConso(AVL* a, long consommation, int id_noeud);
void ecrire(AVL* a, FILE* fichier);
AVL* recupererFichier(FILE* fichier);
void traitementTotal(FILE* fichier_tmp, FILE* fichier_final);
int est_nombre_valide(const char* str);
void traitement_fichier(FILE* fichier, AVL* a);
void ecrire_infixe(AVL* a, FILE* fichier);
#endif // ALV_H
