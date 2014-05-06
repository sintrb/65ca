/**
functions.c
Robin 2014-05-05
**/

#include "define.h"
#include "functions.h"

#include <stdio.h>

t_val curval = 0x00;
t_val curaddr = 0x0000;

FILE *fp = NULL;

const char *ofile = "output.bin";

void writeout(t_val v){
	unsigned char buf[1];
	v &= 0x00ff;
	if(!fp){
		fp = fopen(ofile, "wb");
		if(!fp){
			fprintf(stderr, "open %s for write fail\n", ofile);
			exit(1);
		}
	}


	D("[%02x]", v);

	buf[0] = (unsigned char)v;
	fwrite(buf, 1, 1,  fp);

	++curaddr;
}

t_val cal_readdr(t_val nowaddr, t_val tagaddr){
	t_val bt;
	if(tagaddr > nowaddr && (tagaddr - nowaddr) <= 256){
		bt = tagaddr - nowaddr - 1;
	}
	else if(tagaddr <= nowaddr && (nowaddr - tagaddr) <= 255){
		bt = 0x00ff - (nowaddr - tagaddr);
	}
	else{
		M_ERROR("out of address range");
	}
}

void endout(){
	if(fp){
		fclose(fp);
		fp = NULL;
	}
}
