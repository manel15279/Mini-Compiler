 #include<String.h>
#include <stdio.h>
#include <stdlib.h>
        //declaration
		typedef struct
		{
		char name[20];
		int type;           // 0 = int     1 = float     -1 = aucun type
		int nature;         // 0 = variable      1 = constante     -1 = aucune nature
		float valeur;
		} element;

	 //initialisation 
     element ts[100]={[0 ... 99] ={"", -1, -1, 0}};

		// un compteur pour la table des symboles
        int compteur = 0;
		
        //fonction de recherche
		int recherche(char entite[]){
	  int i = 0;
		while(i < compteur){
		if (strcmp(entite, ts[i].name) == 0) return i;
		i++;}
		return -1;
		}
		
  // fonction d'insertion
    void inserer(char entite[], int tp, int nat, float val){
	strcpy(ts[compteur].name, entite); 
	ts[compteur].type = tp;
	ts[compteur].nature = nat;
	ts[compteur].valeur = val;
	compteur ++;
	}

  // fonction d'affichage
	void afficher (){
	printf("\t/*********************** Table des symboles ***************************/\n");
	printf("\t|      Name      |      Type      |      Nature      |\n");
	int i = 0;
	  while(i < compteur){
		printf("\t|%s              |%d              |%d               |\n", ts[i].name, ts[i].type, ts[i].nature);
		i++;
	   }
	}
	
	//focntion de la double declaration
	int declaration(char entite[]){
	int pos=recherche(entite);
	if (pos != -1){  
	    if(ts[pos].type != -1) return 1; 
	}
	else return 0;
	}

	// fonction de l'incompatibilité des types
	int CompatibleType(int t1, int t2){
    if(t1 == t2) return 1;
    return 0;
    }
	
	// fonction modification de constante
    int ModifCst(char entite[]){
	int pos = recherche(entite);
	if(ts[pos].nature == 0) return 1;
	else return 0;
	}

	// la fonction qui retourne le type d'une entite
	int retournetype(char entite[]){
	int pos = recherche(entite);
	return ts[pos].type;
	}

// fonction qui ajoute la valeur de l'identifiant
void insererval(char entite[], float val){
int pos = recherche(entite);
ts[pos].valeur = val;
}

//fonction qui retourne la valeur d'un identifiant
float retourneval(char entite[]){
int pos = recherche(entite);
return ts[pos].valeur;
}
 // fonction qui insere le type 
void inserertype(int type){
int i = 0;
while(i<compteur){
	if(ts[i].type == -1) ts[i].type = type; 
	 i++;
}
}


int cond(float val1,int c,float val2){
switch (c){
 
case '1': if(val1<val2) return 1; else return 0;
case '2': if(val1>val2) return 1; else return 0;
case '3': if(val1==val2) return 1; else return 0;
case '4': if(val1!=val2) return 1; else return 0;
case '5': if(val1>=val2) return 1; else return 0;
case '6': if(val1<=val2) return 1; else return 0;
}
}