%{
#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
unsigned short line = 1;
unsigned short column = 1;
%}
INTEGER 0|[1-9][0-9]*|\([-+][0-9]+\)
FLOAT ((0|[1-9][0-9]*)\.[0-9]+)|\([-+][0-9]+\.[0-9]+\)
CHAR \'.\'
STRING \".*\"
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
%%
{INTEGER} {
	long int entier;
	if(yytext[0]=='(') entier = strtol(yytext+1, NULL, 10); // Le 1er caractère est le +/-
	else entier = strtol(yytext, NULL, 10);
	if(entier >= -32768 && entier <= 32767){
		inserer(yytext, 'N', yyleng);
		column+=yyleng;
	}
	else printf("Dépassement de capacité : ligne %d : %s\n", yylineno, yytext);
}
{FLOAT} {inserer(yytext, 'F', yyleng); column+=yyleng;}
{CHAR} {inserer(yytext, 'C', yyleng); column+=yyleng;}
{STRING} {inserer(yytext, 'T', yyleng); column+=yyleng;}
{KEYWORD} {inserer(yytext, 'K', yyleng); column+=yyleng;}
{ARITH_OPERATOR} {inserer(yytext, 'O', yyleng); column+=yyleng;}
{SEPARATOR} {inserer(yytext, 'S', yyleng); column+=yyleng;}
{IDENTIFIER} {inserer(yytext, 'I', yyleng); column+=yyleng;} 
"//".+ {} // Ignorer les commentaires
[a-z]+|. {printf("Erreur lexical : ligne %d colonne %d : %s\n",line,column,yytext);}
\n {line++; column=0;}
%%
int main(int argc, char * argv[]){
	if(argc==2){
		yyin = fopen(argv[1],"r");
	}
	yylex();
	afficher();
	return 0;
}