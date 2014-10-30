#include <string.h>
#include <stdio.h>
#include "TS.h"
typedef struct elements {char nom[10]; char type; char nature; unsigned short taille;} element;
element ts[500]; // Le tableau de symbols
unsigned short fin = 0;
int rechercher(const char * entite){
	int i;
	for(i=0; i<fin && strcmp(ts[i].nom,entite)!=0; i++); // Parcourir le tableau de début jusqu'à le dernière entité
	if(i==fin) return -1; // Entité non trouvée
	else return i; // L'indice de l'entité
}
void inserer(const char * entite){
	int position = rechercher(entite);
	if(position==-1){ // Nouvelle entité
		fin++;
		strcpy(ts[fin].nom,entite); // Insérer l'entité
	}
	else{}
}
void afficher(){
	printf("------------\n");
	printf("|%-10s|\n","Nom");
	printf("------------\n");
	int i;
	for(i=0;i<fin;i++) printf("|%-10s|\n",ts[i].nom);
	printf("------------\n");
}
