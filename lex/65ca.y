
%{
#include<stdio.h>
#define YYINPUT()	yyinput()

extern int yylineno;

void yyerror(const char *err);
int yylex();

%}

// keywords
%token DEFINE STRING
// var
%token BYTE WORD ZPADDR ADDR IDENT
// char
%token EQU

// INS
%token LDA LDY LDX

%%

lines : 
	  line
	| line lines
;

line :
	  instruction
	| internal
	| '\n'
	| '\t'
;

instruction :
	  LDA ADDR {
		// printf("ADDR");
	}
	| LDA BYTE {
		// printf("BYTE");
	}
	| LDA ZPADDR {
		// printf("ZPADDR");
	}
;

internal :
	  DEFINE IDENT EQU BYTE {
		// printf("int define k=v");
	}
;

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


