%option noyywrap yylineno

%{
#include<stdio.h>
#include "65ca.tab.h"
#define YYINPUT()	yyinput()

%}


OCT [0-9]
HEX [0-9a-fA-F]
BIN [0-1]


%%

\n[\t\n\r]* {
	// printf("\n");
}


\"[^\"]*\" {
	// printf("S");
	return STRING;
}

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
}

".define" {
	// printf("DF(%d)", yylineno);
	return DEFINE;
}

lda {
	// printf("LDA");
	return LDA;
}

ldy {
	// printf("LDY");
	return LDY;
}



[ t]*=[ t]* {
	// printf("EQU");
	return EQU;
}

\#\${HEX}{2} {
	// printf("BYTE");
	return BYTE;
}

\#\$HEX{4} {
	// printf("WORD");
	return WORD;
}

\$HEX{4} {
	// printf("ADDR");
	return ADDR;
}

\$HEX{2} {
	// printf("ZPADDR");
	return ZPADDR;
}

[a-zA-Z][a-zA-Z0-9_]* {
	// printf("IDENT");
	return IDENT;
}

%%

