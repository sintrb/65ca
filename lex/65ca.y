
%{
#include "define.h"
#include "functions.h"
#include "instructions.h"

%}

// flag
%token ERR

// var
%token BYTE WORD ZPADDR ADDR IDENT NUM

// I
%token LDA LDX LDY STA STX STY TAX TXA TAY TYA TSX TXS ADC SBC INC DEC INX DEX INY DEY AND ORA EOR CLC SEC CLD SED CLV CLI SEI CMP CPX CPY BIT ASL LSR ROL ROR PHA PLA PHP PLP JMP BEQ BNE BCS BCC BMI BPL BVS BVC JSR RTS INT NOP RTI BRK

// char
%token X Y NL L_BRACE R_BRACE L_BRACKET R_BRACKET L_PARENTHESIS R_PARENTHESIS L_ANGLE R_ANGLE COMMA COLON SEMICOLON EQUAL POUND


// commond
%token CMD_ORG CMD_LAB


%%

lines 
	: lines line
	| line
;

line
	: instruction
	| commond
	| NL {
		D("\n");
	}
;


addr : ADDR { D(" -ADDR-"); };
byte
	: BYTE
	| NUM { CURVAL &= 0x00ff; }
	| L_ANGLE ADDR {
		CURVAL &= 0x00ff;
	}
	| R_ANGLE ADDR {
		CURVAL = (CURVAL >> 8) & 0x00ff;
	}
;
zpaddr : ZPADDR { D(" -ZPADDR-"); };
xaddr : addr COMMA X { D(" -XADDR-"); };
yaddr : addr COMMA Y { D(" -YADDR-"); };
xzpaddr : zpaddr COMMA X { D(" -XZPADDR-"); };
yzpaddr : zpaddr COMMA Y { D(" -YZPADDR-"); };
idiraddr : L_PARENTHESIS addr R_PARENTHESIS { D(" -IDIRADDR-"); };
xidiraddr : L_PARENTHESIS zpaddr COMMA X R_PARENTHESIS { D(" -XIDIRADDR-"); };
yidiraddr : L_PARENTHESIS zpaddr R_PARENTHESIS COMMA Y { D(" -YIDIRADDR-"); };

instruction
	: LDA xidiraddr { M_WRITE_BYTE(0xa1); }
	| LDA zpaddr { M_WRITE_BYTE(0xa5); }
	| LDA byte { M_WRITE_BYTE(0xa9); }
	| LDA addr { M_WRITE_WORD(0xad); }
	| LDA yidiraddr { M_WRITE_BYTE(0xb1); }
	| LDA xzpaddr { M_WRITE_BYTE(0xb5); }
	| LDA yaddr { M_WRITE_WORD(0xb9); }
	| LDA xaddr { M_WRITE_WORD(0xbd); }
	| LDX byte { M_WRITE_BYTE(0xa2); }
	| LDX zpaddr { M_WRITE_BYTE(0xa6); }
	| LDX addr { M_WRITE_WORD(0xae); }
	| LDX yzpaddr { M_WRITE_BYTE(0xb6); }
	| LDX yaddr { M_WRITE_WORD(0xbe); }
	| LDY byte { M_WRITE_BYTE(0xa0); }
	| LDY zpaddr { M_WRITE_BYTE(0xa4); }
	| LDY addr { M_WRITE_WORD(0xac); }
	| LDY xzpaddr { M_WRITE_BYTE(0xb4); }
	| LDY xaddr { M_WRITE_WORD(0xbc); }
	| STA xidiraddr { M_WRITE_BYTE(0x81); }
	| STA zpaddr { M_WRITE_BYTE(0x85); }
	| STA addr { M_WRITE_WORD(0x8d); }
	| STA yidiraddr { M_WRITE_BYTE(0x91); }
	| STA xzpaddr { M_WRITE_BYTE(0x95); }
	| STA yaddr { M_WRITE_WORD(0x99); }
	| STA xaddr { M_WRITE_WORD(0x9d); }
	| STX zpaddr { M_WRITE_BYTE(0x86); }
	| STX addr { M_WRITE_WORD(0x8e); }
	| STX yzpaddr { M_WRITE_BYTE(0x96); }
	| STY zpaddr { M_WRITE_BYTE(0x84); }
	| STY addr { M_WRITE_WORD(0x8c); }
	| STY xzpaddr { M_WRITE_BYTE(0x94); }
	| TAX  { M_WRITE_CMD(0xaa); }
	| TXA  { M_WRITE_CMD(0x8a); }
	| TAY  { M_WRITE_CMD(0xa8); }
	| TYA  { M_WRITE_CMD(0x98); }
	| TSX  { M_WRITE_CMD(0xba); }
	| TXS  { M_WRITE_CMD(0x9a); }
	| ADC xidiraddr { M_WRITE_BYTE(0x61); }
	| ADC zpaddr { M_WRITE_BYTE(0x65); }
	| ADC byte { M_WRITE_BYTE(0x69); }
	| ADC addr { M_WRITE_WORD(0x6d); }
	| ADC yidiraddr { M_WRITE_BYTE(0x71); }
	| ADC xzpaddr { M_WRITE_BYTE(0x75); }
	| ADC yaddr { M_WRITE_WORD(0x79); }
	| ADC xaddr { M_WRITE_WORD(0x7d); }
	| SBC xidiraddr { M_WRITE_BYTE(0xe1); }
	| SBC zpaddr { M_WRITE_BYTE(0xe5); }
	| SBC byte { M_WRITE_BYTE(0xe9); }
	| SBC addr { M_WRITE_WORD(0xed); }
	| SBC yidiraddr { M_WRITE_BYTE(0xf1); }
	| SBC xzpaddr { M_WRITE_BYTE(0xf5); }
	| SBC yaddr { M_WRITE_WORD(0xf9); }
	| SBC xaddr { M_WRITE_WORD(0xfd); }
	| INC zpaddr { M_WRITE_BYTE(0xe6); }
	| INC addr { M_WRITE_WORD(0xee); }
	| INC xzpaddr { M_WRITE_BYTE(0xf6); }
	| INC xaddr { M_WRITE_WORD(0xfe); }
	| DEC zpaddr { M_WRITE_BYTE(0xc6); }
	| DEC addr { M_WRITE_WORD(0xce); }
	| DEC xzpaddr { M_WRITE_BYTE(0xd6); }
	| DEC xaddr { M_WRITE_WORD(0xde); }
	| INX  { M_WRITE_CMD(0xe8); }
	| DEX  { M_WRITE_CMD(0xca); }
	| INY  { M_WRITE_CMD(0xc8); }
	| DEY  { M_WRITE_CMD(0x88); }
	| AND xidiraddr { M_WRITE_BYTE(0x21); }
	| AND zpaddr { M_WRITE_BYTE(0x25); }
	| AND byte { M_WRITE_BYTE(0x29); }
	| AND addr { M_WRITE_WORD(0x2d); }
	| AND yidiraddr { M_WRITE_BYTE(0x31); }
	| AND xzpaddr { M_WRITE_BYTE(0x35); }
	| AND yaddr { M_WRITE_WORD(0x39); }
	| AND xaddr { M_WRITE_WORD(0x3d); }
	| ORA xidiraddr { M_WRITE_BYTE(0x01); }
	| ORA zpaddr { M_WRITE_BYTE(0x05); }
	| ORA byte { M_WRITE_BYTE(0x09); }
	| ORA addr { M_WRITE_WORD(0x0d); }
	| ORA yidiraddr { M_WRITE_BYTE(0x11); }
	| ORA xzpaddr { M_WRITE_BYTE(0x15); }
	| ORA yaddr { M_WRITE_WORD(0x19); }
	| ORA xaddr { M_WRITE_WORD(0x1d); }
	| EOR xidiraddr { M_WRITE_BYTE(0x41); }
	| EOR zpaddr { M_WRITE_BYTE(0x45); }
	| EOR byte { M_WRITE_BYTE(0x49); }
	| EOR addr { M_WRITE_WORD(0x4d); }
	| EOR yidiraddr { M_WRITE_BYTE(0x51); }
	| EOR xzpaddr { M_WRITE_BYTE(0x55); }
	| EOR yaddr { M_WRITE_WORD(0x59); }
	| EOR xaddr { M_WRITE_WORD(0x5d); }
	| CLC  { M_WRITE_CMD(0x18); }
	| SEC  { M_WRITE_CMD(0x38); }
	| CLD  { M_WRITE_CMD(0xd8); }
	| SED  { M_WRITE_CMD(0xf8); }
	| CLV  { M_WRITE_CMD(0xb8); }
	| CLI  { M_WRITE_CMD(0x58); }
	| SEI  { M_WRITE_CMD(0x78); }
	| CMP xidiraddr { M_WRITE_BYTE(0xc1); }
	| CMP zpaddr { M_WRITE_BYTE(0xc5); }
	| CMP byte { M_WRITE_BYTE(0xc9); }
	| CMP addr { M_WRITE_WORD(0xcd); }
	| CMP yidiraddr { M_WRITE_BYTE(0xd1); }
	| CMP xzpaddr { M_WRITE_BYTE(0xd5); }
	| CMP yaddr { M_WRITE_WORD(0xd9); }
	| CMP xaddr { M_WRITE_WORD(0xdd); }
	| CPX byte { M_WRITE_BYTE(0xe0); }
	| CPX zpaddr { M_WRITE_BYTE(0xe4); }
	| CPX addr { M_WRITE_WORD(0xec); }
	| CPY byte { M_WRITE_BYTE(0xc0); }
	| CPY zpaddr { M_WRITE_BYTE(0xc4); }
	| CPY addr { M_WRITE_WORD(0xcc); }
	| BIT zpaddr { M_WRITE_BYTE(0x24); }
	| BIT addr { M_WRITE_WORD(0x2c); }
	| ASL  { M_WRITE_CMD(0x0a); }
	| ASL zpaddr { M_WRITE_BYTE(0x06); }
	| ASL addr { M_WRITE_WORD(0x0e); }
	| ASL xzpaddr { M_WRITE_BYTE(0x16); }
	| ASL xaddr { M_WRITE_WORD(0x1e); }
	| LSR  { M_WRITE_CMD(0x4a); }
	| LSR zpaddr { M_WRITE_BYTE(0x46); }
	| LSR addr { M_WRITE_WORD(0x4e); }
	| LSR xzpaddr { M_WRITE_BYTE(0x56); }
	| LSR xaddr { M_WRITE_WORD(0x5e); }
	| ROL  { M_WRITE_CMD(0x2a); }
	| ROL zpaddr { M_WRITE_BYTE(0x26); }
	| ROL addr { M_WRITE_WORD(0x2e); }
	| ROL xzpaddr { M_WRITE_BYTE(0x36); }
	| ROL xaddr { M_WRITE_WORD(0x3e); }
	| ROR  { M_WRITE_CMD(0x6a); }
	| ROR zpaddr { M_WRITE_BYTE(0x66); }
	| ROR addr { M_WRITE_WORD(0x6e); }
	| ROR xzpaddr { M_WRITE_BYTE(0x76); }
	| ROR xaddr { M_WRITE_WORD(0x7e); }
	| PHA  { M_WRITE_CMD(0x48); }
	| PLA  { M_WRITE_CMD(0x68); }
	| PHP  { M_WRITE_CMD(0x08); }
	| PLP  { M_WRITE_CMD(0x28); }
	| JMP addr { M_WRITE_WORD(0x4c); }
	| JMP idiraddr { M_WRITE_WORD(0x6c); }
	| BEQ addr { M_WRITE_REL(0xf0); }
	| BNE addr { M_WRITE_REL(0xd0); }
	| BCS addr { M_WRITE_REL(0xb0); }
	| BCC addr { M_WRITE_REL(0x90); }
	| BMI addr { M_WRITE_REL(0x30); }
	| BPL addr { M_WRITE_REL(0x10); }
	| BVS addr { M_WRITE_REL(0x70); }
	| BVC addr { M_WRITE_REL(0x50); }
	| JSR addr { M_WRITE_WORD(0x20); }
	| RTS  { M_WRITE_CMD(0x60); }
	| INT addr { M_WRITE_WORD(0x00); }
	| NOP  { M_WRITE_CMD(0xea); }
	| RTI  { M_WRITE_CMD(0x40); }
	| BRK  { M_WRITE_CMD(0x00); }
;

commond
	: CMD_ORG addr { M_SETCURADDR(CURVAL); }
	| cmd_lab
	| cmd_keyval
;

cmd_keyval
	: IDENT EQUAL addr {
		cmd_label(curident, curval, ADDR);
	}
	| IDENT EQUAL byte {
		cmd_label(curident, curval, BYTE);
	}
	| IDENT EQUAL zpaddr {
		cmd_label(curident, curval, ZPADDR);
	}
;

cmd_lab
	: CMD_LAB IDENT EQUAL addr { cmd_label(curident, curval, ADDR); }
	| CMD_LAB IDENT EQUAL byte { cmd_label(curident, curval, BYTE); }
	| CMD_LAB IDENT EQUAL zpaddr { cmd_label(curident, curval, ZPADDR); }
	/* for error */
	| CMD_LAB ADDR EQUAL { cmd_label(curident, curval, ADDR); }
	| CMD_LAB BYTE EQUAL { cmd_label(curident, curval, BYTE); }
	| CMD_LAB ZPADDR EQUAL { cmd_label(curident, curval, ZPADDR); }
	| IDENT COLON { cmd_label(curident, curaddr, ADDR); }
;
%%



