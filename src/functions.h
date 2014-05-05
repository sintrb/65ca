/**
functions.h
Robin 2014-05-05
**/


#ifndef FUNCTIONS_H

#include "define.h"

extern t_val curval;


#define M_WRITECMD(_cmd) writeout(_cmd);;
#define M_WRITEBYTE(_cmd) M_WRITECMD(_cmd);writeout(curval);
#define M_WRITEWORD(_cmd) M_WRITECMD(_cmd);writeout(curval);writeout(curval>>8);
#define M_WRITEREL(_cmd) M_WRITEBYTE(_cmd)

// write out
void writeout(t_val v);

#endif
