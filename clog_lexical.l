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
{INTEGER} {printf("%s est un INTEGER\n",yytext);}
{FLOAT} {printf("%s est un FLOAT\n",yytext);}
{CHAR} {printf("%s est un CHAR\n",yytext);}
{STRING} {printf("%s est un STRING\n",yytext);}
{KEYWORD} {printf("%s est un KEYWORD\n",yytext);}
{SEPARATOR} {printf("%s est un SEPARATOR\n",yytext);}
{IDENTIFIER} {printf("%s est un IDENTIFIER\n",yytext);}
"//".+ {printf("%s est un COMMENT\n",yytext);}
.+ {printf("%s ERREUR\n",yytext);}
%%
int main(int argc, char * argv[]){
	if(argc==2){
		yyin = fopen(argv[1],"r");
	}
	yylex();
	return 0;
}