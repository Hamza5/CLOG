#include <string.h>
#include <stdio.h>
#include "TS.h"
typedef struct elements {char nom[9]; char type; char nature; unsigned short taille;} element;
// nom : AND 25.5 (-2) ; Idf "Programme" 'Y' ...
// type : K (Mot-clé), I (Identificateur), S (Séparateur), O (Opérateur), N (Entier), F (Décimal), C (Caractère), T (Chaîne de caractères)
// nature
// taille : en octets
element ts[500]; // Le tableau de symbols
unsigned short fin = 0;
int rechercher(const char * entite){
	int i;
	for(i=0; i<fin && strcmp(ts[i].nom,entite)!=0; i++); // Parcourir le tableau de début jusqu'à le dernière entité
	if(i==fin) return -1; // Entité non trouvée
	else return i; // L'indice de l'entité
}
void inserer(const char * entite, char type, unsigned short taille){
	int position = rechercher(entite);
	if(position==-1){ // Nouvelle entité
		fin++;
		strcpy(ts[fin].nom,entite); // Insérer le nom de l'entité
		ts[fin].type = type; // Insérer le type de l'entité
		ts[fin].taille = taille; // Insérer la taille de l'entité
	}
}
void afficher(){
	printf("------------\n");
	printf("|%-10s|\n","Nom");
	printf("------------\n");
	int i;
	for(i=0;i<=fin;i++) printf("|%-10s|\n",ts[i].nom);
	printf("------------\n");
}
