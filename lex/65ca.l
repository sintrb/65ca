%option noyywrap yylineno caseless

%{
#include "65ca.tab.h"
#include "define.h"
#include "functions.h"

#define RETTOKEN(t) D(#t);return t;


#define M_ERROR_NOTNUM() M_ERROR("not number");

%}



OCT [0-9]
HEX [0-9a-fA-F]
BIN [0-1]

IDENTPRE [_a-zA-Z]
IDENTSUF [_a-zA-Z0-9]
IDENTNOT [^_^a-z^A-Z^0-9]

NL [;\n\r]


%%

"/*" {
	int c1=0, c2=0;
	for(;;) {
		c2 = YYINPUT();
		if(c2 == EOF)
			break;
		if(c1 == '*' && c2 == '/')
			break;
		c1 = c2;
	}
}

"//" {
	int c = 0;
	while(c != '\n' && c != EOF)
		c = YYINPUT();
	#ifdef DEBUG_MODE
		if(c == '\n')
			D("\n");
	#endif
}




LDA { RETTOKEN(LDA); }
LDX { RETTOKEN(LDX); }
LDY { RETTOKEN(LDY); }
STA { RETTOKEN(STA); }
STX { RETTOKEN(STX); }
STY { RETTOKEN(STY); }
TAX { RETTOKEN(TAX); }
TXA { RETTOKEN(TXA); }
TAY { RETTOKEN(TAY); }
TYA { RETTOKEN(TYA); }
TSX { RETTOKEN(TSX); }
TXS { RETTOKEN(TXS); }
ADC { RETTOKEN(ADC); }
SBC { RETTOKEN(SBC); }
INC { RETTOKEN(INC); }
DEC { RETTOKEN(DEC); }
INX { RETTOKEN(INX); }
DEX { RETTOKEN(DEX); }
INY { RETTOKEN(INY); }
DEY { RETTOKEN(DEY); }
AND { RETTOKEN(AND); }
ORA { RETTOKEN(ORA); }
EOR { RETTOKEN(EOR); }
CLC { RETTOKEN(CLC); }
SEC { RETTOKEN(SEC); }
CLD { RETTOKEN(CLD); }
SED { RETTOKEN(SED); }
CLV { RETTOKEN(CLV); }
CLI { RETTOKEN(CLI); }
SEI { RETTOKEN(SEI); }
CMP { RETTOKEN(CMP); }
CPX { RETTOKEN(CPX); }
CPY { RETTOKEN(CPY); }
BIT { RETTOKEN(BIT); }
ASL { RETTOKEN(ASL); }
LSR { RETTOKEN(LSR); }
ROL { RETTOKEN(ROL); }
ROR { RETTOKEN(ROR); }
PHA { RETTOKEN(PHA); }
PLA { RETTOKEN(PLA); }
PHP { RETTOKEN(PHP); }
PLP { RETTOKEN(PLP); }
JMP { RETTOKEN(JMP); }
BEQ { RETTOKEN(BEQ); }
BNE { RETTOKEN(BNE); }
BCS { RETTOKEN(BCS); }
BCC { RETTOKEN(BCC); }
BMI { RETTOKEN(BMI); }
BPL { RETTOKEN(BPL); }
BVS { RETTOKEN(BVS); }
BVC { RETTOKEN(BVC); }
JSR { RETTOKEN(JSR); }
RTS { RETTOKEN(RTS); }
INT { RETTOKEN(INT); }
NOP { RETTOKEN(NOP); }
RTI { RETTOKEN(RTI); }
BRK { RETTOKEN(BRK); }

;NUMBER
\#\${HEX}{4}{HEX}+ {
	M_ERROR_NOTNUM();
}
\#\${HEX}{4} {
	curval = M_HEX_WORD(yytext+2);
	RETTOKEN(WORD);
}
\#\${HEX}{3} {
	M_ERROR_NOTNUM();
}
\#\${HEX}{2} {
	curval = M_HEX_BYTE(yytext+2);
	RETTOKEN(BYTE);
}

;ADDRESS
\${HEX}{4}{HEX}+ {
	M_ERROR_NOTNUM();
}
${HEX}{4} {
	curval = M_HEX_WORD(yytext+1);
	RETTOKEN(ADDR);
}
${HEX}{3} {
	M_ERROR_NOTNUM();
}
${HEX}{2} {
	curval = M_HEX_BYTE(yytext+1);
	RETTOKEN(ZPADDR);
}

;VALUE
\%{BIN}+ {
	curval = M_BIN_BYTE(yytext+1);
	RETTOKEN(NUM);
}
{OCT}+ {
	curval = M_OCT_BYTE(yytext);
	RETTOKEN(NUM);
}

"{" { RETTOKEN(L_BRACE); }
"}" { RETTOKEN(R_BRACE); }
"[" { RETTOKEN(L_BRACKET); }
"]" { RETTOKEN(R_BRACKET); }
"(" { RETTOKEN(L_PARENTHESIS); }
")" { RETTOKEN(R_PARENTHESIS); }
"<" { RETTOKEN(L_ANGLE); }
">" { RETTOKEN(R_ANGLE); }
"," { RETTOKEN(COMMA); }
":" { RETTOKEN(COLON); }
";" { RETTOKEN(SEMICOLON); }
"=" { RETTOKEN(EQUAL); }



"X" { RETTOKEN(X); }
"Y" { RETTOKEN(Y); }

"#" { RETTOKEN(POUND); }


\.ORG { RETTOKEN(CMD_ORG); }

\.LAB|LABEL {
	curval = CURADDR;
	RETTOKEN(CMD_LAB);
}


{IDENTPRE}{IDENTSUF}* {
	M_SAVEIDENT(yytext);
	D("IDENT");
	return token_label(curident);
}

{NL}+ { return NL; }
[ \t\n] {}
%%
