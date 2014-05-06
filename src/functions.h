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

#define CURVAL	curval
#define CURADDR	curaddr


#define M_WRITECMD(_cmd) writeout(_cmd);;
#define M_WRITEBYTE(_cmd) M_WRITECMD(_cmd);writeout(curval);
#define M_WRITEWORD(_cmd) M_WRITECMD(_cmd);writeout(curval);writeout(curval>>8);
#define M_WRITEREL(_cmd) M_WRITECMD(_cmd);writeout(cal_readdr(CURADDR,CURVAL));

// write out
void writeout(t_val v);

t_val cal_readdr(t_val nowaddr, t_val tagaddr);

void endout();

#endif
