#include <stdio.h>
#include <stdlib.h>

typedef struct _avl{
	int value;
	struct _avl *left;
	struct _avl *right;
	int balance;
} AVL;


int max(int a, int b){
	return (a >= b) ? a : b;
}

int abs(int v){return (v < 0) ? -v : v;}


AVL *createAVL( int v){
	AVL *a = malloc(sizeof(AVL));
	if (a == NULL)
		exit(1);
	a->value = v;
	a->left = NULL;
	a->right = NULL;
	a->balance = 0;
	return a;
}


void addLeftSon(AVL *a, int e){
	if (a==NULL){
		printf("Error empty tree");
		return;
	}
	if (a->left != NULL)
		addLeftSon(a->left, e);
	else{
		AVL *pNew = createAVL(e);
		if (pNew == NULL)
			exit(1);
		a->left = pNew;
	}
}


void addRightSon(AVL *a, int e){
	if (a==NULL){
		printf("Error empty tree");
		return;
	}
	if (a->right != NULL)
		addRightSon(a->right, e);

	AVL *pNew = createAVL(e);
	if (pNew == NULL)
		exit(1);
	a->right = pNew;
}


void parcourPrefixe(AVL *a){
	if (a != NULL){
		printf("%d ", a->value);
		parcourPrefixe(a->left);
		parcourPrefixe(a->right);
	}
}


int treeHeight(AVL *a){
	if (a == NULL)
		return 0;
	if (a->left ==NULL && a->right == NULL)
		return 1;
	return 1 + max(treeHeight(a->left),treeHeight(a->right));
}





void deleteTree(AVL **a){
	if((*a) != NULL){
		if ((*a)->left != NULL)
			deleteTree(&(*a)->left);
		if ((*a)->right != NULL)
			deleteTree(&(*a)->right);
		(*a) = NULL;
	free((*a));
	}
}


void rotateRight(AVL **a){

	if((*a)==NULL)
		return;

	AVL *new = (*a)->left;
	AVL *newright = createAVL((*a)->value);
	if(newright==NULL)
		exit(1);
	
	newright->right = (*a)->right;
	newright->left = new->right;
	newright->balance = treeHeight(newright->right) -treeHeight(newright->left);
	new->right = newright;
	new->balance = treeHeight(new->right) - treeHeight(new->left);
	
	*a = new;
}


void rotateLeft(AVL **a){

	if((*a)==NULL)
		return;

	AVL *new = (*a)->right;
	AVL *newleft = createAVL((*a)->value);
	if(newleft==NULL)
		exit(1);
	
	newleft->left = (*a)->left;
	newleft->right = new->left;
	newleft->balance = treeHeight(newleft->right) - treeHeight(newleft->left);
	new->left = newleft;
	new->balance = treeHeight(new->right) - treeHeight(new->left);
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


int isAVL(AVL *a){
	if(a==NULL)
		return 1;
	if (a->left == NULL && a->right == NULL)
		return 1;

	if (a->balance<-1 || a->balance>1)
		return 0;

	if(isAVL(a->left) && isAVL(a->right))
		return 1;
	else
		return 0;
}


void setBalance(AVL *a){
	if (a != NULL){
		a->balance = treeHeight(a->right) - treeHeight(a->left);
		setBalance(a->right);
		setBalance(a->left);
	}
}


void equilibrium(AVL **a){
	if (!isAVL(*a)){
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
		setBalance(*a);
	}
}


void insertAVL(AVL** a, int e){

	AVL *new = createAVL(e);
	if (new==NULL)
			exit(1);

	if(*a==NULL){
		*a = new;
	}
		
	if((*a)->value != e){
		if((*a)->value > e)
			insertAVL(&((*a)->left),e);
		else
			insertAVL(&((*a)->right),e);
		
		equilibrium(a);
		(*a)->balance = treeHeight((*a)->right) - treeHeight((*a)->left);
	}
}


AVL *mostLeft(AVL *a){
	while(a->left != NULL){
		a = a->left;
	}
	return a;
}
		

AVL *mostRight(AVL *a){
	while(a->right != NULL){
		a = a->right;
	}
	return a;
}


void deleteValueAVL(AVL **a, int v){
	if (*a == NULL) 
		return;

	if ((*a)->left == NULL && (*a)->right == NULL){ // stop condition 1
		if((*a)->value == v)
			deleteTree(a);
		}
	else{
		if ((*a)->value == v){ // find closest value to replace with

			if ((*a)->left == NULL)
				(*a)->value = mostLeft((*a)->right)->value;
			else if ((*a)->right == NULL)
				(*a)->value = mostRight((*a)->left)->value;
			else{
				if(abs(mostRight((*a)->left)->value-v) <= abs(mostLeft((*a)->right)->value-v))
					(*a)->value = mostRight((*a)->left)->value;
				else
					(*a)->value = mostLeft((*a)->right)->value;
			}

			if ((*a)->value < v) // delete copy
				deleteValueAVL((&(*a)->left),  (*a)->value);
			else
				deleteValueAVL(&(*a)->right,  (*a)->value);
		}

		else if(v<(*a)->value)
			deleteValueAVL(&(*a)->left, v);	
		else if(v>(*a)->value)
			deleteValueAVL(&(*a)->right, v);
		(*a)->balance = treeHeight((*a)->right) - treeHeight((*a)->left);
		equilibrium(a);
	}
}

void main(){
	AVL *a = createAVL(10);
	insertAVL(&a,5);
	insertAVL(&a,20);
	insertAVL(&a,15);
	insertAVL(&a,26);
	insertAVL(&a,13);
	insertAVL(&a,17);
	parcourPrefixe(a);
	printf("\n");
	insertAVL(&a,28);
	deleteValueAVL(&a, 17);
	parcourPrefixe(a);
	printf("\n");
}






















