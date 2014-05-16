/**
label.h
Robin 2014-05-07
**/

#include "define.h"
#include "basefuns.h"
#include "functions.h"
#include "segment.h"

// 值类型
struct valobj
{
	t_value value;
	t_token token;
	t_refcount refcount;
	struct label * label;
};

typedef struct valobj t_valobj;

// 标签任务
struct labeltask
{
	struct filepos filepos;
	struct segment *segment;
	t_value addr;
};

#define valobj_info(_vo) D("(%s ref:%d)", (_vo)->label ? (_vo)->label->name:"", (_vo)->refcount);
#define valobj_del(_vo) {D("free");valobj_info(_vo); FREE(_vo);(_vo)=NULL;}
#define valobj_retain(_vo) {D("retain");valobj_info(_vo);++((_vo)->refcount);}
#define valobj_release(_vo) {D("release");valobj_info(_vo);--((_vo)->refcount); if(!((_vo)->refcount))valobj_del(_vo);}

struct valobj *label_newval(t_token tk, t_value val);



enum labelstatus {
	LABEL_STATUS_UNKNOWN = 0,
	LABEL_STATUS_KNOWN
};

struct label
{
	char *name;
	struct valobj *val;
	struct filepos filepos;
	enum labelstatus status;

	t_list tasks;
};

extern t_map labels;

// 初始化label
void label_init();

// 创建新标签
struct label * label_new();

// 创建标签任务
struct labeltask *label_newtask();

// 获取标签
struct label * label_get(const char *name, t_bool autoadd);

// 添加任务
void label_addtask(struct label *lab, struct labeltask *tsk);

// 执行任务
void label_dotask(struct label *lab);

// 输出标签信息
void label_detail(struct label * lab);
