%{
#include <stdio.h>
// #define YYSTYPE struct s
extern FILE * yyin;
extern ts;
extern unsigned short line, column;
%}
%union{
	int entier;
	float decimal;
	char * entite;
}
%token INTEGER FLOAT CHAR STRING TYPE COMP_OPERATOR ARITH_OPERATOR LOGIC_OPERATOR FUNCTION IF ELSE FOR END IDENTIFIER
%token SEMICOLON OPEN_ACO CLOSE_ACO OPEN_PARENT CLOSE_PARENT EQUAL DOUBLE_DOT OPEN_BRACE CLOSE_BRACE COMMA AT PIPE
%start S
%%
S : IDENTIFIER OPEN_ACO OPEN_ACO var_dec CLOSE_ACO OPEN_ACO code CLOSE_ACO CLOSE_ACO;
var_dec : TYPE DOUBLE_DOT IDENTIFIER sep |;
sep : PIPE IDENTIFIER sep | SEMICOLON var_dec;
code : ;
%%
int yyerror(char * message){
	printf("Erreur syntaxique : ligne %u colonne %u\n", line, column);
}
int main(int argc, char * argv[]){
	if(argc > 1){
		int i;
		for(i=1; i<argc; i++){
			printf("\nAnalyse lexical & syntaxique du fichier %s\n", argv[i]);
			yyin = fopen(argv[i],"r");
			yyparse();
			afficher();
		}
	}
	else printf("Usage : %s 'Chemin_du_fichier'\n", argv[0]);
	return 0;
}