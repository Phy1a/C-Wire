#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

typedef struct {
	int id;
    int capacity;
    int load; // either consumption or production depending on the entity (central or consummer)
} Data;


typedef struct _avl{
	Data data;
	struct _avl *left;
	struct _avl *right;
	int sum;
	int balance;
} AVL;


int max(int a, int b){
	return (a >= b) ? a : b;
}

int min(int a, int b){
	return (a <= b) ? a : b;
}

int abs(int v){return (v < 0) ? -v : v;}


AVL *createAVL(Data d){
	AVL *a = malloc(sizeof(AVL));
	a->data = d;
	a->left = NULL;
	a->right = NULL;
	a->balance = 0;
	a->sum = a->data.capacity +  a->data.load;
	return a;
}


AVL *findInAVL(AVL *a, int v){
	if(a==NULL)
		return NULL;
	if(a->data.id == v)
		return a;
	else if(a->data.id > v)
		findInAVL(a->left, v);
	else
		findInAVL(a->right, v);
}


void parcourPrefixe(AVL *a){
	if (a != NULL){
		printf("(Id : %d ,Capacity : %d, Load : %d, Balance : %d, Sum : %d) ", a->data.id, a->data.capacity, a->data.load, a->balance, a->sum);
		parcourPrefixe(a->left);
		parcourPrefixe(a->right);
	}
}


void deleteTree(AVL **a){
	if((*a) != NULL){
		if ((*a)->left != NULL)
			deleteTree(&(*a)->left);
		if ((*a)->right != NULL)
			deleteTree(&(*a)->right);
		free(&((*a)->data));
		(*a) = NULL;
		free((*a));
	}
}


void rotateRight(AVL **a){
	int eq_n, eq_a;

	AVL *new = (*a)->left;
	(*a)->sum -= new->sum;
	(*a)->left = new->right;
	if((*a)->left != NULL)
		(*a)->sum += new->right->sum;
	new->right = (*a);
	new->sum += (*a)->sum;

	eq_a = (*a)->balance;
	eq_n = new->balance;
	(*a)->balance = eq_a - min(eq_n,0) + 1;
	new->balance = max( max(eq_a+2, eq_a + eq_n + 2), eq_n +1);

	*a = new;
}


void rotateLeft(AVL **a){
	int eq_n, eq_a;

	AVL *new = (*a)->right;
	(*a)->sum -= new->sum;
	(*a)->right = new->left;
	if((*a)->right != NULL)
		(*a)->sum += new->left->sum;
	new->left = (*a);
	new->sum += (*a)->sum;

	eq_a = (*a)->balance;
	eq_n = new->balance;
	(*a)->balance = eq_a - max(eq_n,0) - 1;
	new->balance = min( min(eq_a-2, eq_a + eq_n - 2), eq_n - 1);

	*a = new;
}


void doubleLeftRotate(AVL **a){ 
	rotateRight(&((*a)->right));
	rotateLeft(a);
}


void doubleRightRotate(AVL **a){
	rotateLeft(&((*a)->left));
	rotateRight(a);
}


void equilibrium(AVL **a){
	if ((*a)->balance<-1){
		if((*a)->left->balance<=0)
				rotateRight(a);
			else
				doubleRightRotate(a);
	}
	else if((*a)->balance>1){
		if((*a)->right->balance>=0)
			rotateLeft(a);
		else
			doubleLeftRotate(a);
	}
}


void insertAVL_exe(AVL** a, Data d, int *b){

	if(*a==NULL){
		AVL *new = createAVL(d);
		if (new==NULL)
			exit(1);
		*a = new;
		return;
	}

	if((*a)->data.id != d.id){
		(*a)->sum += d.load + d.capacity;
		if((*a)->data.id > d.id){
			insertAVL_exe(&((*a)->left),d,b);
			if (*b){
				(*a)->balance -= *b;
				equilibrium(a);
				*b = abs((*a)->balance);
			}
		}
		else{
			insertAVL_exe(&((*a)->right),d,b);
			if (*b){
				(*a)->balance += *b;
				equilibrium(a);
				*b = abs((*a)->balance);
			}
		}
	}
}


void insertAVL(AVL** a, Data d){
	int b = 1;
	insertAVL_exe(a,d,&b);
}


void main(){
	 Data d = {3,3,0};
	 Data d2 = {4,7,0};
	 Data d3 = {5,0,5};
	 AVL *a = createAVL(d);
	 printf("\n");
	 insertAVL(&a,d2);
	 insertAVL(&a,d3);
	 parcourPrefixe(a);
	 printf("\n");
	 parcourPrefixe(findInAVL(a,5));
	 printf("\n");
	 deleteTree(&a);
	 printf("Deleted tree\n");
	 parcourPrefixe(a);
}






















