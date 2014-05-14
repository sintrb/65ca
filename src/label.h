/**
label.h
Robin 2014-05-07
**/
#include "define.h"
#include "basefuns.h"
#include "functions.h"

enum labelstatus {
	LABEL_STATUS_UNKNOWN = 0,
	LABEL_STATUS_KNOWN
};

struct label
{
	char *name;
	struct valobj *val;
	struct filepos filepos;
	t_link tasks;
};

extern t_map labels;

// 创建新标签
struct label * label_new();

// 获取标签
struct label * label_get(const char *name, t_bool autoadd);

