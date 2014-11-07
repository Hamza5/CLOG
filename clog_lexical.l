%{
#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
unsigned short line = 1;
unsigned short column = 1;
%}
INTEGER 0|[1-9][0-9]*|\([-+][0-9]+\)
	// 0 15 (+172) (-22) ...
FLOAT ((0|[1-9][0-9]*)\.[0-9]+)|\([-+][0-9]+\.[0-9]+\)
	// 0.521 (+3.0) (-193.56) ...
CHAR \'.\'
	// 'H' '5' ...
STRING \".*\"
	// "CLOG" "Hello" "" ...
TYPE INTEGER|FLOAT|CHAR|STR|CONST|VECTOR
ARITH_OPERATOR "+"|"-"|"*"|"/"
LOGIC_OPERATOR AND|OR|NOT
COMP_OPERATOR G|L|GE|LE|EQ|DI
IO READ|DISPLAY
CONDITION IF|ELSE|END
LOOP FOR|PAS
KEYWORD {TYPE}|{COMP_OPERATOR}|{LOGIC_OPERATOR}|{IO}|{CONDITION}|{LOOP}
SEPARATOR ";"|"{"|"}"|"("|")"|"="|":"|"["|"]"|","|"@"|" "|\t
IDENTIFIER [A-Z][a-z0-9]{0,7}
	// Compil Tp5 ...
%%
{INTEGER} {
	long int entier;
	if(yytext[0]=='(') entier = strtol(yytext+1, NULL, 10); // Si le 1er caractère est le ( alors commencer la convertion de +/- (Position n°1)
	else entier = strtol(yytext, NULL, 10); // Sinon, convertir toute l'entité
	if(entier >= -32768 && entier <= 32767){
		inserer(yytext, 'N', 'C', yyleng);
		column+=yyleng;
	}
	else printf("Dépassement de capacité : ligne %d colonne %d : %s\n", line, column, yytext);
}
{FLOAT} {inserer(yytext, 'F', 'C', yyleng); column+=yyleng;}
{CHAR} {inserer(yytext, 'C', 'C', yyleng); column+=yyleng;}
{STRING} {inserer(yytext, 'T', 'C', yyleng); column+=yyleng;}
{KEYWORD} {inserer(yytext, 'K', 'C', yyleng); column+=yyleng;}
{ARITH_OPERATOR} {inserer(yytext, 'O', 'C', yyleng); column+=yyleng;}
{SEPARATOR} {inserer(yytext, 'S', 'C', yyleng); column+=yyleng;}
{IDENTIFIER} {inserer(yytext, 'I', 'V', yyleng); column+=yyleng;} 
"//".+ {} // Ignorer les commentaires
[a-z]+|. {printf("Erreur lexical : ligne %d colonne %d : %s\n",line,column,yytext);}
\n {line++; column=1;}
%%
int main(int argc, char * argv[]){
	if(argc > 1){
		int i;
		for(i=1; i<argc; i++){
			printf("\nAnalyse lexical du fichier %s\n", argv[i]);
			yyin = fopen(argv[i],"r");
			yylex();
			afficher();
		}
	}
	else printf("Usage : %s 'Chemin_du_fichier'\n", argv[0]);
	return 0;
}