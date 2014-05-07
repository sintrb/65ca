/**
define.h
Robin 2014-05-05
**/

#ifndef DEFINE_H
#define DEFINE_H

#define DEBUG_MODE 1

#define MALLOC(_size) malloc(_size)
#define FREE(_size) free(_pointer)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "basefuns.h"
#include "65ca.tab.h"

#define YYINPUT()	yyinput()

// 逻辑
#define FALSE	0
#define TRUE	(!FALSE)

#ifdef DEBUG_MODE
	#define D printf
#else
	#define D 
#endif

#define YYINPUT()	yyinput()
#define curlineno yylineno
extern char *yytext;
extern int yylineno;
int yylex();
void yyerror(const char *err);
typedef unsigned int t_val;
typedef unsigned char t_bool;

#define M_ERROR(_fmt, _args...) {fprintf(stderr,"error: %s(%d): ", curfile, curlineno); fprintf(stderr, _fmt, ##_args); destory(); exit(1);}



enum linetype
{
	LINETYPE_NORMAL, // 正常状态
};

extern linetype curlinetype;



// begin 数据转换
// 十六进制字节
#define M_HEX_BYTE(_h) (htoi(_h) & 0x00ff)
// 十六进制字
#define M_HEX_WORD(_h) (htoi(_h) & 0xffff)
// 二进制字节
#define M_BIN_BYTE(_b) (btoi(_b) & 0x00ff)
// 十进制字节
#define M_OCT_BYTE(_o) (atoi(_o) & 0x00ff)

// end 数据转换


#endif

