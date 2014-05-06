
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


addr : ADDR { D(" -ADDR-"); };
byte : BYTE { D(" -BYTE-"); };
zpaddr : ZPADDR { D(" -ZPADDR-"); };
xaddr : addr CM X { D(" -XADDR-"); };
yaddr : addr CM Y { D(" -YADDR-"); };
xzpaddr : zpaddr CM X { D(" -XZPADDR-"); };
yzpaddr : zpaddr CM Y { D(" -YZPADDR-"); };
idiraddr : BL addr BR { D(" -IDIRADDR-"); };
xidiraddr : BL zpaddr CM X BR { D(" -XIDIRADDR-"); };
yidiraddr : BL zpaddr BR CM Y { D(" -YIDIRADDR-"); };

instruction
	: LDA xidiraddr { M_WRITEBYTE(0xa1); }
	| LDA zpaddr { M_WRITEBYTE(0xa5); }
	| LDA byte { M_WRITEBYTE(0xa9); }
	| LDA addr { M_WRITEWORD(0xad); }
	| LDA yidiraddr { M_WRITEBYTE(0xb1); }
	| LDA xzpaddr { M_WRITEBYTE(0xb5); }
	| LDA yaddr { M_WRITEWORD(0xb9); }
	| LDA xaddr { M_WRITEWORD(0xbd); }
	| LDX byte { M_WRITEBYTE(0xa2); }
	| LDX zpaddr { M_WRITEBYTE(0xa6); }
	| LDX addr { M_WRITEWORD(0xae); }
	| LDX yzpaddr { M_WRITEBYTE(0xb6); }
	| LDX yaddr { M_WRITEWORD(0xbe); }
	| LDY byte { M_WRITEBYTE(0xa0); }
	| LDY zpaddr { M_WRITEBYTE(0xa4); }
	| LDY addr { M_WRITEWORD(0xac); }
	| LDY xzpaddr { M_WRITEBYTE(0xb4); }
	| LDY xaddr { M_WRITEWORD(0xbc); }
	| STA xidiraddr { M_WRITEBYTE(0x81); }
	| STA zpaddr { M_WRITEBYTE(0x85); }
	| STA addr { M_WRITEWORD(0x8d); }
	| STA yidiraddr { M_WRITEBYTE(0x91); }
	| STA xzpaddr { M_WRITEBYTE(0x95); }
	| STA yaddr { M_WRITEWORD(0x99); }
	| STA xaddr { M_WRITEWORD(0x9d); }
	| STX zpaddr { M_WRITEBYTE(0x86); }
	| STX addr { M_WRITEWORD(0x8e); }
	| STX yzpaddr { M_WRITEBYTE(0x96); }
	| STY zpaddr { M_WRITEBYTE(0x84); }
	| STY addr { M_WRITEWORD(0x8c); }
	| STY xzpaddr { M_WRITEBYTE(0x94); }
	| TAX  { M_WRITECMD(0xaa); }
	| TXA  { M_WRITECMD(0x8a); }
	| TAY  { M_WRITECMD(0xa8); }
	| TYA  { M_WRITECMD(0x98); }
	| TSX  { M_WRITECMD(0xba); }
	| TXS  { M_WRITECMD(0x9a); }
	| ADC xidiraddr { M_WRITEBYTE(0x61); }
	| ADC zpaddr { M_WRITEBYTE(0x65); }
	| ADC byte { M_WRITEBYTE(0x69); }
	| ADC addr { M_WRITEWORD(0x6d); }
	| ADC yidiraddr { M_WRITEBYTE(0x71); }
	| ADC xzpaddr { M_WRITEBYTE(0x75); }
	| ADC yaddr { M_WRITEWORD(0x79); }
	| ADC xaddr { M_WRITEWORD(0x7d); }
	| SBC xidiraddr { M_WRITEBYTE(0xe1); }
	| SBC zpaddr { M_WRITEBYTE(0xe5); }
	| SBC byte { M_WRITEBYTE(0xe9); }
	| SBC addr { M_WRITEWORD(0xed); }
	| SBC yidiraddr { M_WRITEBYTE(0xf1); }
	| SBC xzpaddr { M_WRITEBYTE(0xf5); }
	| SBC yaddr { M_WRITEWORD(0xf9); }
	| SBC xaddr { M_WRITEWORD(0xfd); }
	| INC zpaddr { M_WRITEBYTE(0xe6); }
	| INC addr { M_WRITEWORD(0xee); }
	| INC xzpaddr { M_WRITEBYTE(0xf6); }
	| INC xaddr { M_WRITEWORD(0xfe); }
	| DEC zpaddr { M_WRITEBYTE(0xc6); }
	| DEC addr { M_WRITEWORD(0xce); }
	| DEC xzpaddr { M_WRITEBYTE(0xd6); }
	| DEC xaddr { M_WRITEWORD(0xde); }
	| INX  { M_WRITECMD(0xe8); }
	| DEX  { M_WRITECMD(0xca); }
	| INY  { M_WRITECMD(0xc8); }
	| DEY  { M_WRITECMD(0x88); }
	| AND xidiraddr { M_WRITEBYTE(0x21); }
	| AND zpaddr { M_WRITEBYTE(0x25); }
	| AND byte { M_WRITEBYTE(0x29); }
	| AND addr { M_WRITEWORD(0x2d); }
	| AND yidiraddr { M_WRITEBYTE(0x31); }
	| AND xzpaddr { M_WRITEBYTE(0x35); }
	| AND yaddr { M_WRITEWORD(0x39); }
	| AND xaddr { M_WRITEWORD(0x3d); }
	| ORA xidiraddr { M_WRITEBYTE(0x01); }
	| ORA zpaddr { M_WRITEBYTE(0x05); }
	| ORA byte { M_WRITEBYTE(0x09); }
	| ORA addr { M_WRITEWORD(0x0d); }
	| ORA yidiraddr { M_WRITEBYTE(0x11); }
	| ORA xzpaddr { M_WRITEBYTE(0x15); }
	| ORA yaddr { M_WRITEWORD(0x19); }
	| ORA xaddr { M_WRITEWORD(0x1d); }
	| EOR xidiraddr { M_WRITEBYTE(0x41); }
	| EOR zpaddr { M_WRITEBYTE(0x45); }
	| EOR byte { M_WRITEBYTE(0x49); }
	| EOR addr { M_WRITEWORD(0x4d); }
	| EOR yidiraddr { M_WRITEBYTE(0x51); }
	| EOR xzpaddr { M_WRITEBYTE(0x55); }
	| EOR yaddr { M_WRITEWORD(0x59); }
	| EOR xaddr { M_WRITEWORD(0x5d); }
	| CLC  { M_WRITECMD(0x18); }
	| SEC  { M_WRITECMD(0x38); }
	| CLD  { M_WRITECMD(0xd8); }
	| SED  { M_WRITECMD(0xf8); }
	| CLV  { M_WRITECMD(0xb8); }
	| CLI  { M_WRITECMD(0x58); }
	| SEI  { M_WRITECMD(0x78); }
	| CMP xidiraddr { M_WRITEBYTE(0xc1); }
	| CMP zpaddr { M_WRITEBYTE(0xc5); }
	| CMP byte { M_WRITEBYTE(0xc9); }
	| CMP addr { M_WRITEWORD(0xcd); }
	| CMP yidiraddr { M_WRITEBYTE(0xd1); }
	| CMP xzpaddr { M_WRITEBYTE(0xd5); }
	| CMP yaddr { M_WRITEWORD(0xd9); }
	| CMP xaddr { M_WRITEWORD(0xdd); }
	| CPX byte { M_WRITEBYTE(0xe0); }
	| CPX zpaddr { M_WRITEBYTE(0xe4); }
	| CPX addr { M_WRITEWORD(0xec); }
	| CPY byte { M_WRITEBYTE(0xc0); }
	| CPY zpaddr { M_WRITEBYTE(0xc4); }
	| CPY addr { M_WRITEWORD(0xcc); }
	| BIT zpaddr { M_WRITEBYTE(0x24); }
	| BIT addr { M_WRITEWORD(0x2c); }
	| ASL  { M_WRITECMD(0x0a); }
	| ASL zpaddr { M_WRITEBYTE(0x06); }
	| ASL addr { M_WRITEWORD(0x0e); }
	| ASL xzpaddr { M_WRITEBYTE(0x16); }
	| ASL xaddr { M_WRITEWORD(0x1e); }
	| LSR  { M_WRITECMD(0x4a); }
	| LSR zpaddr { M_WRITEBYTE(0x46); }
	| LSR addr { M_WRITEWORD(0x4e); }
	| LSR xzpaddr { M_WRITEBYTE(0x56); }
	| LSR xaddr { M_WRITEWORD(0x5e); }
	| ROL  { M_WRITECMD(0x2a); }
	| ROL zpaddr { M_WRITEBYTE(0x26); }
	| ROL addr { M_WRITEWORD(0x2e); }
	| ROL xzpaddr { M_WRITEBYTE(0x36); }
	| ROL xaddr { M_WRITEWORD(0x3e); }
	| ROR  { M_WRITECMD(0x6a); }
	| ROR zpaddr { M_WRITEBYTE(0x66); }
	| ROR addr { M_WRITEWORD(0x6e); }
	| ROR xzpaddr { M_WRITEBYTE(0x76); }
	| ROR xaddr { M_WRITEWORD(0x7e); }
	| PHA  { M_WRITECMD(0x48); }
	| PLA  { M_WRITECMD(0x68); }
	| PHP  { M_WRITECMD(0x08); }
	| PLP  { M_WRITECMD(0x28); }
	| JMP addr { M_WRITEWORD(0x4c); }
	| JMP idiraddr { M_WRITEWORD(0x6c); }
	| BEQ addr { M_WRITEREL(0xf0); }
	| BNE addr { M_WRITEREL(0xd0); }
	| BCS addr { M_WRITEREL(0xb0); }
	| BCC addr { M_WRITEREL(0x90); }
	| BMI addr { M_WRITEREL(0x30); }
	| BPL addr { M_WRITEREL(0x10); }
	| BVS addr { M_WRITEREL(0x70); }
	| BVC addr { M_WRITEREL(0x50); }
	| JSR addr { M_WRITEWORD(0x20); }
	| RTS  { M_WRITECMD(0x60); }
	| INT addr { M_WRITEWORD(0x00); }
	| NOP  { M_WRITECMD(0xea); }
	| RTI  { M_WRITECMD(0x40); }
	| BRK  { M_WRITECMD(0x00); }
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


