#include <stdio.h>
#include "TS.h"
#include "fonctions_semantiques.h"
extern unsigned short errors;
extern unsigned short line;
extern unsigned short column;
void declaration_variable(const char * entite, const char type, const char nature, const short taille){
	if(rechercher(entite)){
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : %s a été déja déclarée !\n", line, column, entite);
	}
	else{
		if(nature=='T' && taille<1){
			errors++;
			fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : %s vecteur de taille inférieur à 1 !\n", line, column, entite);
			return;
		}
		inserer(entite, type, nature, taille);
	}
}
int verifierDeclaration(const char * variable){
	if(!rechercher(variable)){
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : %s non déclarée !\n", line, column, variable);
		return 0;
	}
	return 1;
}
char verifierCompatibiliteArithmetique(char type1, char type2){
	if(type1==type2) return type1;
	else if(type1=='F' && type2=='N' || type1=='N' && type2=='F') return 'F';
	else{
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : Les types %s et %s sont incompatibles !\n", line, column, type_str(type1), type_str(type2));
		return '\0';
	}
}
int verifierCompatibiliteAffectation(char type1, char type2){
	if(type1==type2) return 1;
	else {
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : Impossible d'affecter %s à %s !\n", line, column, type_str(type2), type_str(type1));
		return 0;
	}
}
int verifierIndiceVecteur(char type){
	if(type != 'N'){
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : l'indice d'un élément de vecteur doit être un entier !\n", line, column);
		return 0;
	}
	else return 1;
}