#include <string.h>
#include <stdio.h>
#include "TS.h"
typedef struct elements {char nom[40]; char type; char nature; unsigned short taille;} element;
// nom : AND 25.5 (-2) ; Idf "Programme" 'Y' ...
// type : K (Mot-clé), I (Identificateur), S (Séparateur), O (Opérateur), N (Entier), F (Décimal), C (Caractère), T (Chaîne de caractères)
// nature : C (Constante), V (Variable)
// taille : en octets
element ts[500]; // Le tableau de symbols
unsigned short fin = 0;
int rechercher(const char * entite){
	int i;
	for(i=0; i<fin && strcmp(ts[i].nom, entite)!=0; i++); // Parcourir le tableau de début jusqu'à le dernière entité
	if(i==fin) return -1; // Entité non trouvée
	else return i; // L'indice de l'entité
}
void inserer(const char * entite, char type, char nature, unsigned short taille){
	int position = rechercher(entite);
	if(position==-1){ // Nouvelle entité
		strcpy(ts[fin].nom,entite); // Insérer le nom de l'entité
		ts[fin].type = type; // Insérer le type de l'entité
		ts[fin].nature = nature; // Insérer la nature de l'entité
		ts[fin].taille = taille; // Insérer la taille de l'entité
		fin++;
	}
}
void afficher(){
	printf("---------------------------------------.-----.------.-------\n");
	printf("|%-39s|%4s|%6s|%s|\n","Nom","Type","Nature","Taille");
	printf("---------------------------------------.-----.------.-------\n");
	int i;
	for(i=0;i<fin;i++){
		printf("|%-39s|%-4c|%-6c|%7d|\n", ts[i].nom, ts[i].type, ts[i].nature, ts[i].taille);
		printf("---------------------------------------.-----.------.-------\n");
	}
}
