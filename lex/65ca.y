
%{
#include<stdio.h>
#define YYINPUT()	yyinput()

extern int yylineno;

void yyerror(const char *err);
int yylex();


%}

// keywords
%token DEFINE
// var
%token ZPADDR ADDR LABEL STRING
// char
%token EQU
%%
exp:  DEFINE LABEL EQU ADDR
	| DEFINE LABEL EQU ZPADDR

exp:  ADDR
	| ZPADDR
	| exp '+' exp

%%



int main(int arc, char *argv[])
{
	yyparse();
	return 0;
}

extern char *yytext;

void yyerror(const char *err)
{
	printf("%s (line %d): %s\n ",err,yylineno,yytext);
}


