%{
#include <stdio.h>
#include "TS.h"
%}
INTEGER [0-9]+|\(-[0-9]+\)
FLOAT [0-9]+\.[0-9]+|\(-[0-9]+\.[0-9]+\)
CHAR \'.\'
STRING \".*\"
TYPE INTEGER|FLOAT|CHAR|STR|CONST|VECTOR
IDENTIFIER [A-Z][a-z0-9]*
ARITH_OPERATOR "+"|"-"|"*"|"/"
LOGIC_OPERATOR AND|OR|NOT
COMP_OPERATOR G|L|GE|LE|EQ|DI
IO READ|DISPLAY
CONDITION IF|ELSE|END
LOOP FOR|PAS
KEYWORD {TYPE}|{COMP_OPERATOR}|{LOGIC_OPERATOR}|{IO}|{CONDITION}|{LOOP}
SEPARATOR {ARITH_OPERATOR}|";"|"{"|"}"|"("|")"|"="|":"|"["|"]"|","|"@"
%%
{INTEGER} {inserer(yytext);}
{FLOAT} {inserer(yytext);}
{CHAR} {inserer(yytext);}
{STRING} {inserer(yytext);}
{KEYWORD} {inserer(yytext);}
{SEPARATOR} {inserer(yytext);}
{IDENTIFIER} {inserer(yytext);}
"//".+ {}
.+ {printf("Erreur lexical : ligne %d : %s\n",yylineno,yytext);}
%%
int main(int argc, char * argv[]){
	if(argc==2){
		yyin = fopen(argv[1],"r");
	}
	yylex();
	afficher();
	return 0;
}