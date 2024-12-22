#ifndef TRAITEMENT_H
#define TRAITEMENT_H

#include <stdio.h>
#include "avl.h"

void ecrire(AVL* a, FILE* fichier);
AVL* recupererFichier(FILE* fichier);
void traitementTotal(FILE* fichier_tmp, FILE* fichier_final);

#endif
