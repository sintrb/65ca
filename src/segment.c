/**
label.h
Robin 2014-05-15
**/
#include "segment.h"


struct segment * curdefseg = NULL;


struct segment *segment_new(){
	struct segment * seg = (struct segment *)MALLOC(sizeof(struct segment));
	seg->filepos = filepos_curpos();
	seg->name = NULL;
	seg->fill = 0;
	seg->start = 0;
	seg->size = 0;
	seg->data = 0;
	return seg;
}
