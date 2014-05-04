
%{
#include<stdio.h>
#define YYINPUT()	yyinput()

extern int yylineno;

void yyerror(const char *err);
void yyparse();


%}

// keywords
%token DEFINE
// var
%token ZPADDR ADDR LABEL
// char
%token EQU
%%
exp:  DEFINE LABEL EQU ADDR
	| DEFINE LABEL EQU ZPADDR


%%



int main(int arc, char *argv[])
{
	yyparse();
	return 0;
}

void yyerror(const char *err)
{
	printf(" E(L%d):%s\n ",yylineno,err);
}


