#ifndef TRAITEMENT_H
#define TRAITEMENT_H

void ecrire(AVL* a, FILE* fichier);
AVL* recupererFichier(FILE* fichier);
void traitementTotal(FILE* fichier_tmp, FILE* fichier_final);

#endif
