%option noyywrap yylineno caseless

%{
#include<stdio.h>
#include "65ca.tab.h"
#include "define.h"

#define RETTOKEN(t) D(#t);return t;

%}



OCT [0-9]
HEX [0-9a-fA-F]
BIN [0-1]



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


\#\${HEX}{4} { RETTOKEN(WORD); }
\#\${HEX}{2} { RETTOKEN(BYTE); }
${HEX}{4} { RETTOKEN(ADDR); }
${HEX}{2} { RETTOKEN(ZPADDR); }

"(" { RETTOKEN(BL); }
")" { RETTOKEN(BR); }
"," { RETTOKEN(CM); }
"X" { RETTOKEN(X); }
"Y" { RETTOKEN(Y); }


%%

