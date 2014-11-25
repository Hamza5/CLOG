%{
#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
#include "clog_syntaxique.tab.h"
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
FUNCTION READ|DISPLAY
IDENTIFIER [A-Z][a-z0-9]{0,7}
	// Compil Tp5 ...
%%
%{
	extern YYSTYPE yylval;
%}
{INTEGER} {
	long int entier;
	if(yytext[0]=='(') entier = strtol(yytext+1, NULL, 10); // Si le 1er caractère est le ( alors commencer la convertion de +/- (Position n°1)
	else entier = strtol(yytext, NULL, 10); // Sinon, convertir toute l'entité
	if(entier >= -32768 && entier <= 32767){
		/*inserer(yytext, 'N', 'C', yyleng);*/
		column+=yyleng;
		yylval.entier = entier;
		return INTEGER;
	}
	else printf("Dépassement de capacité : ligne %d colonne %d : %s\n", line, column, yytext);
}
{FLOAT} {
	double decimal;
	if(yytext[0]=='(') decimal = strtod(yytext+1, NULL); // Si le 1er caractère est le ( alors commencer la convertion de +/- (Position n°1)
	else decimal = strtod(yytext, NULL); // Sinon, convertir toute l'entité
	/*inserer(yytext, 'F', 'C', yyleng);*/
	column+=yyleng;
	yylval.decimal = decimal;
	return FLOAT;
}
{CHAR} {
	/*inserer(yytext, 'C', 'C', yyleng);*/
	column+=yyleng;
	yylval.entite = yytext;
	return CHAR;
}
{STRING} {
	/*inserer(yytext, 'T', 'C', yyleng);*/
	column+=yyleng;
	yylval.entite = yytext;
	return STRING;
}
{TYPE} {
	/*inserer(yytext, 'K', 'C', yyleng);*/
	column+=yyleng;
	yylval.entite = yytext;
	return TYPE;
}
{COMP_OPERATOR} {
	column+=yyleng;
	yylval.entite = yytext;
	return COMP_OPERATOR;
}
{LOGIC_OPERATOR} {
	column+=yyleng;
	yylval.entite = yytext;
	return LOGIC_OPERATOR;
}
{ARITH_OPERATOR} {
	/*inserer(yytext, 'O', 'C', yyleng);*/
	column+=yyleng;
	yylval.entite = yytext;
	return ARITH_OPERATOR;
}
{FUNCTION} {
	column+=yyleng;
	yylval.entite = yytext;
	return FUNCTION;
}
IF {
	column+=yyleng;
	yylval.entite = yytext;
	return IF;
}
ELSE {
	column+=yyleng;
	yylval.entite = yytext;
	return ELSE;
}
FOR {
	column+=yyleng;
	yylval.entite = yytext;
	return FOR;
}
END {
	column+=yyleng;
	yylval.entite = yytext;
	return END;
}
" "|\t {
	column+=yyleng;
}
";" {
	column+=yyleng;
	yylval.entite = yytext;
	return SEMICOLON;
}
"{" {
	column+=yyleng;
	yylval.entite = yytext;
	return OPEN_ACO;
}
"}" {
	column+=yyleng;
	yylval.entite = yytext;
	return CLOSE_ACO;
}
"(" {
	column+=yyleng;
	yylval.entite = yytext;
	return OPEN_PARENT;
}
")" {
	column+=yyleng;
	yylval.entite = yytext;
	return CLOSE_PARENT;
}
"=" {
	column+=yyleng;
	yylval.entite = yytext;
	return EQUAL;
}
":" {
	column+=yyleng;
	yylval.entite = yytext;
	return DOUBLE_DOT;
}
"[" {
	column+=yyleng;
	yylval.entite = yytext;
	return OPEN_BRACE;
}
"]" {
	column+=yyleng;
	yylval.entite = yytext;
	return CLOSE_BRACE;
}
"," {
	column+=yyleng;
	yylval.entite = yytext;
	return COMMA;
}
"@" {
	column+=yyleng;
	yylval.entite = yytext;
	return AT;
}
"|" {
	column+=yyleng;
	yylval.entite = yytext;
	return PIPE;
}

{IDENTIFIER} {
	/*inserer(yytext, 'I', 'V', yyleng);*/
	column+=yyleng;
	yylval.entite = yytext;
	return IDENTIFIER;
}
"//".* {} // Ignorer les commentaires
\n {line++; column=1;}
[a-z]+|. {
	printf("Erreur lexical : ligne %d colonne %d : %s\n",line,column,yytext);
	column+=yyleng;
}
%%
int yywrap(){ return 1; }