
%{
#include "define.h"
#include "functions.h"
#include "instructions.h"

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
%token BL BR CM X Y NL

%%

lines 
	: lines line
	| line
;

line
	: instruction
	| NL {
		D("\n");
	}
;

ins : LDA | LDX | LDY | STA | STX | STY | TAX | TXA | TAY | TYA | TSX | TXS | ADC | SBC | INC | DEC | INX | DEX | INY | DEY | AND | ORA | EOR | CLC | SEC | CLD | SED | CLV | CLI | SEI | CMP | CPX | CPY | BIT | ASL | LSR | ROL | ROR | PHA | PLA | PHP | PLP | JMP | BEQ | BNE | BCS | BCC | BMI | BPL | BVS | BVC | JSR | RTS | INT | NOP | RTI | BRK
;

instruction
	: ins
	| ins addrtype
;



addr : ADDR { D(" -ADDR-"); };
byte : BYTE { D(" -BYTE-"); };
zpaddr : ZPADDR { D(" -ZPADDR-"); };
xaddr : addr CM X { D(" -XADDR-"); };
yaddr : addr CM Y { D(" -YADDR-"); };
xzpaddr : zpaddr CM X { D(" -XZPADDR-"); };
yzpaddr : zpaddr CM Y { D(" -INDIRADDR-"); };
idiraddr : BL addr BR { D(" -INDIRADDR-"); };
xidiraddr : BL zpaddr CM X BR { D(" -XIDIRADDR-"); };
yidiraddr : BL zpaddr BR CM Y { D(" -YIDIRADDR-"); };


addrtype
	: addr
	| byte
	| zpaddr
	| xaddr
	| yaddr
	| xzpaddr
	| yzpaddr
	| idiraddr
	| xidiraddr
	| yidiraddr
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


