%option noyywrap yylineno caseless

%{
#include "65ca.tab.h"
#include "define.h"
#include "functions.h"

#define RETTOKEN(t) D(#t);return t;

#define RETIDENT()	{M_SAVEIDENT(yytext); D("IDENT"); return token_label(curident);}

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


LDA { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(LDA); }
LDX { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(LDX); }
LDY { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(LDY); }
STA { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(STA); }
STX { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(STX); }
STY { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(STY); }
TAX { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(TAX); }
TXA { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(TXA); }
TAY { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(TAY); }
TYA { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(TYA); }
TSX { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(TSX); }
TXS { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(TXS); }
ADC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(ADC); }
SBC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(SBC); }
INC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(INC); }
DEC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(DEC); }
INX { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(INX); }
DEX { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(DEX); }
INY { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(INY); }
DEY { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(DEY); }
AND { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(AND); }
ORA { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(ORA); }
EOR { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(EOR); }
CLC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(CLC); }
SEC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(SEC); }
CLD { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(CLD); }
SED { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(SED); }
CLV { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(CLV); }
CLI { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(CLI); }
SEI { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(SEI); }
CMP { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(CMP); }
CPX { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(CPX); }
CPY { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(CPY); }
BIT { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BIT); }
ASL { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(ASL); }
LSR { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(LSR); }
ROL { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(ROL); }
ROR { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(ROR); }
PHA { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(PHA); }
PLA { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(PLA); }
PHP { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(PHP); }
PLP { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(PLP); }
JMP { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(JMP); }
BEQ { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BEQ); }
BNE { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BNE); }
BCS { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BCS); }
BCC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BCC); }
BMI { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BMI); }
BPL { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BPL); }
BVS { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BVS); }
BVC { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BVC); }
JSR { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(JSR); }
RTS { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(RTS); }
INT { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(INT); }
NOP { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(NOP); }
RTI { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(RTI); }
BRK { curlinetype = LINETYPE_INSTRUCTION; RETTOKEN(BRK); }

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

\.DEFSEG|DEFINESEGMENT {
	curlinetype = LINETYPE_DEFSEG;
	RETTOKEN(CMD_DEFSEG);
}

NAME {
	if(curlinetype == LINETYPE_DEFSEG){
		RETTOKEN(DEFSEG_NAME);
	}
	else{
		RETIDENT();
	}
}

SIZE {
	if(curlinetype == LINETYPE_DEFSEG){
		RETTOKEN(DEFSEG_SIZE);
	}
	else{
		RETIDENT();
	}
}

START {
	if(curlinetype == LINETYPE_DEFSEG){
		RETTOKEN(DEFSEG_START);
	}
	else{
		RETIDENT();
	}
}

FILL {
	if(curlinetype == LINETYPE_DEFSEG){
		RETTOKEN(DEFSEG_FILL);
	}
	else{
		RETIDENT();
	}
}

{IDENTPRE}{IDENTSUF}* {
	if(curlinetype == LINETYPE_DEFSEG){
		M_SAVEIDENT(yytext);
		D("IDENT");
		return IDENT;
	}
	else{
		RETIDENT();
	}
}

{NL}+ { curlinetype = LINETYPE_NORMAL; return NL; }
[ \t\n] {}
%%
