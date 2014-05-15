/**
functions.h
Robin 2014-05-05
**/


#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include "define.h"
#include "basefuns.h"

// extern t_value curval;
extern t_value curaddr;
extern char * curfile;
extern char curident[256];

// #define CURVAL	curval
#define CURADDR	curaddr


#define M_SETCURADDR(_addr)	curaddr = _addr;

#define M_WRITE_CMD(_cmd) writeout(_cmd);
#define M_WRITE_BYTE(_cmd, _val) M_WRITE_CMD(_cmd);writeout(_val);
#define M_WRITE_WORD(_cmd, _val) M_WRITE_CMD(_cmd);writeout(_val);writeout((_val)>>8);
#define M_WRITE_REL(_cmd, _val) M_WRITE_CMD(_cmd);writeout(cal_readdr(CURADDR,_val));

// begin 编译器

// 初始化编译器
void init();
// 销毁编译器
void destory();

// end 编译器


// 输出

// 输出单字节
void writeout(t_value v);

// end 输出

// begin 计算

// 计算相对偏移值
// 超出范围时报错
t_value cal_readdr(t_value nowaddr, t_value tagaddr);


// end 计算

// begin 内部命令(.xx)

// 添加标签
struct label * cmd_label(const char *name, struct valobj *val);

// end 内部命令

// begin 标签处理
t_token token_label(const char *name);
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

// 编译指令token为ins，值为val的代码行
void ins_compile(t_token ins, struct valobj *val);







#endif
