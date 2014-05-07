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
	t_val val;
	labelstatus status;
	yytokentype token;
	struct filepos filepos;
	t_link tasks;
};


// 创建新标签
struct label * label_new();

