
%{
#include <stdio.h>
#include "define.h"

#define YYINPUT()	yyinput()

extern int yylineno;

void yyerror(const char *err);
int yylex();

%}


// var
%token BYTE WORD ZPADDR ADDR IDENT

// I
%token LDA LDX LDY STA STX STY TAX TXA TAY TYA TSX TXS ADC SBC INC DEC INX DEX INY DEY AND ORA EOR CLC SEC CLD SED CLV CLI SEI CMP CPX CPY BIT ASL LSR ROL ROR PHA PLA PHP PLP JMP BEQ BNE BCS BCC BMI BPL BVS BVC JSR RTS INT NOP RTI BRK


%%

lines 
	: lines line
	| line
;

line
	: instruction
;


instruction
	: lda
;

lda
	: LDA ADDR {
		D(" -ADDR");
	}
	| LDA BYTE {
		D(" -BYTE");
	}
	| LDA ZPADDR {
		D(" -ZPADDR");
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


