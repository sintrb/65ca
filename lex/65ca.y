
%{
#include "define.h"
#include "functions.h"
#include "instructions.h"
#include "65ca.tab.h"

#define COMPILEINS(_ins, _type)	D(#_ins)

%}

%union{
	struct valobj *val;
	yytokentype token;
	char * identname;
}



// flag
%token ERR

// var
%token IDENT

// address
%token NUM 200 ZPADDR 201 ADDR 202 XADDR 203 YADDR 204 XZPADDR 205 YZPADDR 206 IDIRADDR 207 XIDIRADDR 208 YIDIRADDR 209 READDR 210

// NUM
%token BIN HEX OCT

// I
%token LDA 100 LDX 101 LDY 102 STA 103 STX 104 STY 105 TAX 106 TXA 107 TAY 108 TYA 109 TSX 110 TXS 111 ADC 112 SBC 113 INC 114 DEC 115 INX 116 DEX 117 INY 118 DEY 119 AND 120 ORA 121 EOR 122 CLC 123 SEC 124 CLD 125 SED 126 CLV 127 CLI 128 SEI 129 CMP 130 CPX 131 CPY 132 BIT 133 ASL 134 LSR 135 ROL 136 ROR 137 PHA 138 PLA 139 PHP 140 PLP 141 JMP 142 BEQ 143 BNE 144 BCS 145 BCC 146 BMI 147 BPL 148 BVS 149 BVC 150 JSR 151 RTS 152 INT 153 NOP 154 RTI 155 BRK 156

// char
%token X Y NL L_BRACE R_BRACE L_BRACKET R_BRACKET L_PARENTHESIS R_PARENTHESIS L_ANGLE R_ANGLE COMMA COLON SEMICOLON EQUAL POUND DOLLAR


// commond
%token CMD_ORG CMD_LAB CMD_DEFSEG

// defseg
%token DEFSEG_NAME DEFSEG_SIZE DEFSEG_START DEFSEG_FILL

// cal
%token ADD SUB DIV MUL
%left ADD SUB
%left MUL DIV
%right DOLLAR
%right POUND


%type <val> ident addr
%type <token> ins
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


ident
	: ADDR {
		$$ = valobj_new(ADDR, htoi(yytext+1));
	}
	| ZPADDR {
		$$ = valobj_new(ZPADDR, htoi(yytext+1));
	}
	| HEX {
		$$ = valobj_new(NUM, htoi(yytext+2));
	}
	| BIN {
		$$ = valobj_new(NUM, btoi(yytext+1));
	}
	| OCT {
		$$ = valobj_new(NUM, atoi(yytext));
	}
	| ident ADD ident {
		$$ = $1;
		$$->value = $1->value + $3->value;
		valobj_del($3);
	}
	| ident SUB ident {
		$$ = $1;
		$$->value = $1->value - $3->value;
		valobj_del($3);
	}
	| ident MUL ident {
		$$ = $1;
		$$->value = $1->value * $3->value;
		valobj_del($3);
	}
	| ident DIV ident {
		$$ = $1;
		$$->value = $1->value / $3->value;
		valobj_del($3);
	}
	| L_BRACE ident R_BRACE {
		$$ = $2;
	}
;

addr
	: ident {
		$$ = $1;
	}
	| ident COMMA X {
		$$ = $1;
		$$->token = XADDR;
	}
	| ident COMMA Y {
		$$ = $1;
		$$->token = YADDR;
	}
	| L_PARENTHESIS ident R_PARENTHESIS {
		$$ = $2;
		$$->token = IDIRADDR;
	}
	| L_PARENTHESIS ident COMMA X R_PARENTHESIS {
		$$ = $2;
		$$->token = XIDIRADDR;
	}
	| L_PARENTHESIS ident R_PARENTHESIS COMMA Y {
		$$ = $2;
		$$->token = YIDIRADDR;
	}
;

instruction
	: ins addr {
		D(" --%04x(%d)\n", $2->value, $2->token);
	}
	| ins {

	}
;

ins
	: LDA { $$ = LDA; }
	| LDX { $$ = LDX; }
	| LDY { $$ = LDY; }
	| STA { $$ = STA; }
	| STX { $$ = STX; }
	| STY { $$ = STY; }
	| TAX { $$ = TAX; }
	| TXA { $$ = TXA; }
	| TAY { $$ = TAY; }
	| TYA { $$ = TYA; }
	| TSX { $$ = TSX; }
	| TXS { $$ = TXS; }
	| ADC { $$ = ADC; }
	| SBC { $$ = SBC; }
	| INC { $$ = INC; }
	| DEC { $$ = DEC; }
	| INX { $$ = INX; }
	| DEX { $$ = DEX; }
	| INY { $$ = INY; }
	| DEY { $$ = DEY; }
	| AND { $$ = AND; }
	| ORA { $$ = ORA; }
	| EOR { $$ = EOR; }
	| CLC { $$ = CLC; }
	| SEC { $$ = SEC; }
	| CLD { $$ = CLD; }
	| SED { $$ = SED; }
	| CLV { $$ = CLV; }
	| CLI { $$ = CLI; }
	| SEI { $$ = SEI; }
	| CMP { $$ = CMP; }
	| CPX { $$ = CPX; }
	| CPY { $$ = CPY; }
	| BIT { $$ = BIT; }
	| ASL { $$ = ASL; }
	| LSR { $$ = LSR; }
	| ROL { $$ = ROL; }
	| ROR { $$ = ROR; }
	| PHA { $$ = PHA; }
	| PLA { $$ = PLA; }
	| PHP { $$ = PHP; }
	| PLP { $$ = PLP; }
	| JMP { $$ = JMP; }
	| BEQ { $$ = BEQ; }
	| BNE { $$ = BNE; }
	| BCS { $$ = BCS; }
	| BCC { $$ = BCC; }
	| BMI { $$ = BMI; }
	| BPL { $$ = BPL; }
	| BVS { $$ = BVS; }
	| BVC { $$ = BVC; }
	| JSR { $$ = JSR; }
	| RTS { $$ = RTS; }
	| INT { $$ = INT; }
	| NOP { $$ = NOP; }
	| RTI { $$ = RTI; }
	| BRK { $$ = BRK; }
;

%%



