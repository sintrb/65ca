/**
instab.h
Robin 2014-05-13
**/

#include "define.h"


#define INS_COUNT	57
#define INS_ADDR_COUNT	12

#define INSTOKEN_OFFSET	100
#define ADDRTOKEN_OFFSET 200

#define INS_INDEX(_tk)	((_tk)-INSTOKEN_OFFSET)
#define ADDR_INDEX(_tk)	((_tk)-ADDRTOKEN_OFFSET)

struct insobj
{
	t_token ins;
	t_token addr;
	t_value code;
};

extern struct insobj * ins_table[INS_COUNT][INS_ADDR_COUNT];

void instab_init();
struct insobj * insobj_new(t_token ins, t_token addr, t_value code);
struct insobj * instab_get(t_token ins, t_token addr);

