/**
define.h
Robin 2014-05-05
**/

#ifndef DEFINE_H
#define DEFINE_H

#define VERSION_I	114
#define VERSION_S	"1.1.4"

// #define DEBUG_MODE 1


#define MALLOC(_size) malloc(_size)
#define FREE(_pointer) free(_pointer)

typedef unsigned int t_value;
typedef unsigned char t_bool;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "basefuns.h"
#include "65ca.tab.h"
// #include "label.h"

//#define YYINPUT()	YY_INPUT()

// 逻辑
#define FALSE	0
#define TRUE	(!FALSE)

#ifdef DEBUG_MODE
	#define D printf
#else
	#define D 
#endif

#define O printf

#ifndef true
#define true 1
#endif

#ifndef false
#define false 0
#endif

#define curlineno yylineno
extern char *yytext;
extern int yylineno;
int yylex();
void yyerror(const char *err);

extern char *infile;
extern char *outfile;

#define M_ERROR(_fmt, _args...) {fprintf(stderr,"error: %s(%d): ", curfile, curlineno); fprintf(stderr, _fmt, ##_args); destory(); exit(1);}
#define M_WARN(_fmt, _args...) {fprintf(stdout,"warn: %s(%d): ", curfile, curlineno); fprintf(stdout, _fmt, ##_args); fprintf(stdout, "\n"); }

enum linetype
{
	LINETYPE_NORMAL, // 正常状态
	LINETYPE_INSTRUCTION, // 指令
	LINETYPE_DEFSEG // 定义段
};

extern enum linetype curlinetype;
typedef enum yytokentype t_token;
typedef unsigned int t_refcount;

#define MARK()	D("%s: %d", __FILE__, __LINE__)

#endif

