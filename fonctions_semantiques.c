#include <stdio.h>
#include "TS.h"
#include "fonctions_semantiques.h"
#include <regex.h> // Pour les expressions régulières
#include <malloc.h>
#include <string.h>
extern unsigned short errors;
extern unsigned short line;
extern unsigned short column;
void declaration_variable(const char * entite, const char type, const char nature, const short taille){
	if(rechercher(entite)){ // Variable déclarée précédemment.
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : %s a été déja déclarée !\n", line, column, entite);
	}
	else{
		if(nature=='T' && taille<1){ // Vecteur avec une taille nulle ou négative.
			errors++;
			fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : %s vecteur de taille inférieur à 1 !\n", line, column, entite);
			return;
		}
		inserer(entite, type, nature, taille);
	}
}
int verifierDeclaration(const char * variable){
	if(!rechercher(variable)){ // Variable non déclarée.
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : %s non déclarée !\n", line, column, variable);
		return 0;
	}
	return 1;
}
char verifierCompatibiliteArithmetique(char type1, char type2){
	if(type1==type2) return type1; // Les types identiques sont compatibles.
	else if(type1=='F' && type2=='N' || type1=='N' && type2=='F') return 'F'; // Les types entier et décimal sont compatibles pour les opérations arithméthiques.
	else{
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : Les types %s et %s sont incompatibles pour une opération arithméthique !\n", line, column, type_str(type1), type_str(type2));
		return '\0';
	}
}
int verifierCompatibiliteAffectation(char type1, char type2){
	if(type1==type2) return 1;
	else {
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : Impossible d'affecter un opérand %s à un opérand %s !\n", line, column, type_str(type2), type_str(type1));
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
int validerFormatRead(char * format, char type){ // Vérifier la validité et la compatiblité du format par rapport au type de la variable.
	regex_t regexp; // Declaration d'un objet de type expression régulière
	int matched;
	regcomp(&regexp, "\"[$]\"", 0); // Format  $
	matched = !regexec(&regexp, format, 0, NULL, 0); // Tester le format avec l'expression régulière.
	if(matched && type == 'N') return 1; // et le type entier
	regcomp(&regexp, "\"%\"", 0); // Format %
	matched = !regexec(&regexp, format, 0, NULL, 0);
	if(matched && type == 'F') return 1; // et le type décimal
	regcomp(&regexp, "\"#\"", 0); // Format #
	matched = !regexec(&regexp, format, 0, NULL, 0);
	if(matched && type == 'T') return 1; // et le type chaine de caractères
	regcomp(&regexp, "\"&\"", 0); // Format &
	matched = !regexec(&regexp, format, 0, NULL, 0);
	if(matched && type == 'C') return 1; // et le type caractère
	errors++;
	fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : L'identificateur de type %s ne correspend pas au formattage !\n", line, column, type_str(type));
	return 0;
}
int validerFormatDisplay(char * format, char type){
	regex_t regexp;
	int matched;
	regcomp(&regexp, "\".*[$].*\"", 0);
	matched = !regexec(&regexp, format, 0, NULL, 0);
	if(matched && type == 'N') return 1;
	regcomp(&regexp, "\".*%.*\"", 0);
	matched = !regexec(&regexp, format, 0, NULL, 0);
	if(matched && type == 'F') return 1;
	regcomp(&regexp, "\".*#.*\"", 0);
	matched = !regexec(&regexp, format, 0, NULL, 0);
	if(matched && type == 'T') return 1;
	regcomp(&regexp, "\".*&.*\"", 0);
	matched = !regexec(&regexp, format, 0, NULL, 0);
	if(matched && type == 'C') return 1;
	errors++;
	fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : L'identificateur de type %s ne correspend pas au formattage !\n", line, column, type_str(type));
	return 0;
}
int verifierCompatibiliteComparaison(char type1, char type2){
	if(type1==type2) return 1;
	else if(type1=='F' && type2=='N' || type1=='N' && type2=='F') return 1;
	else{
		errors++;
		fprintf(stderr, "Erreur sémantique : ligne %u colonne %u : Les types %s et %s sont incompatibles pour la comparaison !\n", line, column, type_str(type1), type_str(type2));
		return 0;
	}
}
//la fonction pour l'ajout  les quadruplets
/* --------------------------- structure de la liste des quadruplets ---------------------------------------*/

typedef struct quadr{
    char oper[100]; // pour le stockage des differents operateurs telsque  Br , *,/,+,- ....etc 
    char op1[100];   
    char op2[100];  
    char res[100];  // resultat
    struct quadr *svt;
  }quadr;
 quadr*teteQ=NULL, * queue=NULL;


 void Quad(char *oper,char *op1,char *op2,char *res)
 {
 quadr* tempo;
 tempo=(quadr*)malloc( sizeof(quadr) );
 strcpy(tempo->oper, oper );
 strcpy(tempo->op1, op1 );
 strcpy(tempo->op2, op2 );
 strcpy(tempo->res, res);
 tempo->svt=NULL;
 if(teteQ==NULL){ teteQ=queue=tempo;} else{queue->svt=tempo;queue=tempo;}
 }
//affichage des QUADRUPLETS
void afficher_quadr()
{

FILE *yyout_qdr;       /* --> pointeur qui contient l'@ dy fichier qudruplet.qdr */
int nbr_quad=1;//0    /* la numerotation des quadruplets commence a partir du numero 1 */ 
quadr *k;

yyout_qdr=fopen("quadruplet.qdr","wt"); /* ---> fichier dans lequel s'affichent les quadruplets générés */ 

for(k=teteQ;k!=NULL;k=k->svt)
 
 { 
fprintf(yyout_qdr," %d - ( %s  ,  %s  ,  %s  ,  %s ) \n",nbr_quad,k->oper,k->op1,k->op2,k->res); 
 nbr_quad++;
 }

fclose(yyout_qdr); /* fermeture du fichier Quadruplet.qdr */ 

}



