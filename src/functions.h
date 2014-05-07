/**
functions.h
Robin 2014-05-05
**/


#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include "define.h"
#include "basefuns.h"

extern t_val curval;
extern t_val curaddr;
extern char * curfile;
extern char curident[256];

#define CURVAL	curval
#define CURADDR	curaddr
#define M_SAVEIDENT(_s) strncpy(curident, _s, sizeof(curident))

#define M_SETCURADDR(_addr)	curaddr = _addr;

#define M_WRITE_CMD(_cmd) writeout(_cmd);;
#define M_WRITE_BYTE(_cmd) M_WRITE_CMD(_cmd);writeout(curval);
#define M_WRITE_WORD(_cmd) M_WRITE_CMD(_cmd);writeout(curval);writeout(curval>>8);
#define M_WRITE_REL(_cmd) M_WRITE_CMD(_cmd);writeout(cal_readdr(CURADDR,CURVAL));

// begin 编译器

// 初始化编译器
void init();
// 销毁编译器
void destory();

// end 编译器


// 输出

// 输出单字节
void writeout(t_val v);

// end 输出

// begin 计算

// 计算相对偏移值
// 超出范围时报错
t_val cal_readdr(t_val nowaddr, t_val tagaddr);


// end 计算

// begin 内部命令(.xx)

// 添加标签
struct label * cmd_label(const char *name, t_val val, yytokentype token);

// end 内部命令

// begin 标签处理
yytokentype token_label(const char *name);
// end 表情处理

// begin 文件位置
struct filepos
{
	char * filename;
	unsigned int lineno;
};

// 获取当前文件位置
struct filepos filepos_curpos();
// end 文件位置









#endif
