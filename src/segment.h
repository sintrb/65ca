/**
label.h
Robin 2014-05-15
**/
#ifndef SEGMENT_H
#define SEGMENT_H

#include "define.h"
#include "basefuns.h"
#include "functions.h"
#define CURSEG curseg
extern t_map segments;
extern struct segment * curdefseg;
extern struct segment * curseg;
enum segmentflag {
	SEGMENT_FLAG_RAW = 0,
	SEGMENT_FLAG_WROTE,
	SEGMENT_FLAG_UNKNOWN
};
struct segment
{
	/* 属性 */
	char * name;
	t_value start;
	t_value size;
	t_value fill;
	
	/* 内部值 */
	t_value index;
	struct filepos filepos;
	unsigned char * data;
	enum segmentflag * flag;
};

// 初始化segment
void segment_init();

// 新建段
struct segment *segment_new();

// 向段写入数据(字节)
t_value segment_write(struct segment *seg, t_value val);

// 设置地址
void segment_setaddr(struct segment *seg, t_value addr);

// 跳过数据
void segment_skip(struct segment *seg, t_value cnt);

// 输出段信息
void segment_detail(struct segment *seg);

extern struct segment * curdefseg;

#endif

