%{
#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
#include "clog_syntaxique.tab.h"
unsigned short line = 1;
unsigned short column = 1;
unsigned short errors = 0;
%}
INTEGER 0|[1-9][0-9]*|\([-+][0-9]+\)
	// 0 15 (+172) (-22) ...
FLOAT ((0|[1-9][0-9]*)\.[0-9]+)|\([-+][0-9]+\.[0-9]+\)
	// 0.521 (+3.0) (-193.56) ...
CHAR \'.\'
	// 'H' '5' ...
STRING \".*\"
	// "CLOG" "Hello" "" ...
TYPE INTEGER|FLOAT|CHAR|STRING
COMP_OPERATOR G|L|GE|LE|EQ|DI
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
		column+=yyleng;
		yylval.entier = entier;
		return INTEGER;
	}
	else fprintf(stderr, "Dépassement de capacité : ligne %d colonne %d : %s\n", line, column, yytext);
}
{FLOAT} {
	double decimal;
	if(yytext[0]=='(') decimal = strtod(yytext+1, NULL); // Si le 1er caractère est le ( alors commencer la convertion de +/- (Position n°1)
	else decimal = strtod(yytext, NULL); // Sinon, convertir toute l'entité
	column+=yyleng;
	yylval.decimal = decimal;
	return FLOAT;
}
{CHAR} {
	column+=yyleng;
	yylval.entite = yytext;
	return CHAR;
}
{STRING} {
	column+=yyleng;
	yylval.entite = yytext;
	return STRING;
}
{TYPE} {
	column+=yyleng;
	yylval.entite = yytext;
	if(!strcmp(yytext,"INTEGER")) return TYPE_INTEGER;
	else if(!strcmp(yytext,"FLOAT")) return TYPE_FLOAT;
	else if(!strcmp(yytext,"CHAR")) return TYPE_CHAR;
	else return TYPE_STRING;
}
CONST {
	column+=yyleng;
	yylval.entite = yytext;
	return CONST;
}
VECTOR {
	column+=yyleng;
	yylval.entite = yytext;
	return VECTOR;
}

{COMP_OPERATOR} {
	column+=yyleng;
	yylval.entite = yytext;
	return COMP_OPERATOR;
}
NOT {
	column+=yyleng;
	yylval.entite = yytext;
	return AND;
}
AND {
	column+=yyleng;
	yylval.entite = yytext;
	return AND;
}
OR {
	column+=yyleng;
	yylval.entite = yytext;
	return OR;
}
"+" {
	column+=yyleng;
	yylval.entite = yytext;
	return PLUS;
}
"-" {
	column+=yyleng;
	yylval.entite = yytext;
	return MINUS;
}
"*" {
	column+=yyleng;
	yylval.entite = yytext;
	return STAR;
}
"/" {
	column+=yyleng;
	yylval.entite = yytext;
	return SLASH;
}
READ {
	column+=yyleng;
	yylval.entite = yytext;
	return READ;
}
DISPLAY {
	column+=yyleng;
	yylval.entite = yytext;
	return DISPLAY;
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
	column+=yyleng;
	yylval.entite = yytext;
	return IDENTIFIER;
}
"//".* {} // Ignorer les commentaires
\n {line++; column=1;}
[a-z]+|. {
	errors++;
	fprintf(stderr, "Erreur lexical : ligne %d colonne %d : %s\n",line,column,yytext);
	column+=yyleng;
}
%%
int yywrap(){ return 1; }