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
#define CURADDR	(curseg?curseg->index+curseg->start:0)


#define M_SETCURADDR(_addr)	{if(!curseg)M_ERROR("not in any segment")else segment_setaddr(curseg, _addr);};
#define M_CHECKCURSEG()	{if(!curseg){M_ERROR("not in any segment");}}


// begin 编译器

// 初始化编译器
void init();
// 销毁编译器
void destory();

// end 编译器


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

// 结束段定义
void cmd_end_defseg();

// 显示信息
void cmd_info(const char *name);

// 切换段
void cmd_seg(const char *name);

// 写入数据
void cmd_dat(t_list list);

// 包含文件
void cmd_inc(const char *name);

#endif
