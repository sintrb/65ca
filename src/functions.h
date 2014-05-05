/**
functions.h
Robin 2014-05-05
**/


#ifndef FUNCTIONS_H

#include "define.h"

extern t_val curval;


#define M_WRITEBYTE(_cmd) writeout(_cmd);writeout(curval);
#define M_WRITEWORD(_cmd) writeout(_cmd);writeout(curval);writeout(curval>>8);

// write out
void writeout(t_val v);

#endif
