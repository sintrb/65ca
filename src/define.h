
#ifndef DEFINE_H

#define DEBUG_MODE 1

#define YYINPUT()	yyinput()


#ifdef DEBUG_MODE
	#define D printf
#else
	#define D 
#endif


#endif

