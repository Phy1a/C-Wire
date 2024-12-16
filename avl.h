#ifndef ALV_H
#define ALV_H

#include "data.h"

typedef struct _avl{
	Data data;
	struct _avl *left;
	struct _avl *right;
	unsigned long long sum;
	int balance;
} AVL;

int max(int a, int b);
int min(int a, int b);
int abs(int v);

AVL *createAVL(Data d);
AVL *findInAVL(AVL *a, int v);
void parcourInfixe(AVL *a);
void deleteTree(AVL **a);
void rotateRight(AVL **a);
void rotateLeft(AVL **a);
void doubleLeftRotate(AVL **a);
void doubleRightRotate(AVL **a);
void equilibrium(AVL **a);
void insertAVL_exe(AVL** a, Data d, int *b, int *error);
int insertAVL(AVL** a, Data d);


#endif // ALV_H