
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

// char
%token BL BR CM X Y

%%

lines 
	: lines line
	| line
;

line
	: instruction
;

ins : LDA | LDX | LDY | STA | STX | STY | TAX | TXA | TAY | TYA | TSX | TXS | ADC | SBC | INC | DEC | INX | DEX | INY | DEY | AND | ORA | EOR | CLC | SEC | CLD | SED | CLV | CLI | SEI | CMP | CPX | CPY | BIT | ASL | LSR | ROL | ROR | PHA | PLA | PHP | PLP | JMP | BEQ | BNE | BCS | BCC | BMI | BPL | BVS | BVC | JSR | RTS | INT | NOP | RTI | BRK
;

instruction
	: ins
	| ins addr
;


addr
	: ADDR {
		D(" -ADDR-");
	}
	| BYTE {
		D(" -BYTE-");
	}
	| ZPADDR {
		D(" -ZPADDR-");
	}
	| ADDR CM X {
		D(" -XADDR-");
	}
	| ADDR CM Y {
		D(" -YADDR-");
	}
	| ZPADDR CM X {
		D(" -XZPADDR-");
	}
	| ZPADDR CM Y {
		D(" -YZPADDR-");
	}
	| BL ADDR BR {
		D(" -INDIRADDR-");
	}
	| BL ZPADDR CM X BR{
		D(" -XINDIRADDR-");
	}
	| BL ZPADDR BR CM Y {
		D(" -INDIRYADDR-");
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


