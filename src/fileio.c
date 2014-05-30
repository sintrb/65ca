/**
fileio.c
Robin 2014-05-19
**/

#include "fileio.h"
#include "functions.h"
#include <unistd.h>
#ifdef WIN32
	// windows
	#define SPLIT '\\'
#else
	// linux
	#define SPLIT '/'
#endif

#define ISSPLIT(_c) ((_c)=='\\' || (_c)=='/')

FILE *fileio_open(const char *filename, const char *type){
	FILE *fp = fopen(filename, type);
	D("--OPEN: %s : %s\n", filename, type);
	if(!fp){
		M_ERROR("open %s failed", filename);
	}
	return fp;
}

char *fileio_abspath_ix(const char *base, int end, const char *relative, int start){
	if(ISSPLIT(relative[start]) && relative[start+2]==':'){
		// abs
		return str_clone(relative);
	}

	// re
	if(relative[start]=='.' && ISSPLIT(relative[start+1])){
		// ./
		++start;
		while(relative[start] && ISSPLIT(relative[start])){
			++start;
		}

		while(end>0 && !ISSPLIT(base[end])){
			--end;
		}
	}
	else if(relative[start]=='.' && relative[start+1]=='.' && ISSPLIT(relative[start+2])){
		// ../
		++start;
		++start;
		while(relative[start] && ISSPLIT(relative[start])){
			++start;
		}

		if(end>0)
			--end;
		while(end>0 && !ISSPLIT(base[end])){
			--end;
		}
	}
	else{
		while(end>0 && !ISSPLIT(base[end])){
			--end;
		}
	}

	if(relative[start] == '.'){
		return fileio_abspath_ix(base, end, relative, start);
	}
	else{
		int l1 = end+1;
		int l2 = strlen(relative+start);
		char * s = (char*)MALLOC(l1+l2+1);
		strncpy(s, base, l1);
		strncpy(s+l1, relative+start, l2);
		s[l1+l2] = '\0';
		return s;
	}
}

char *fileio_abspath(const char *base, const char *relative){
	char * s = NULL;
	char *abspath = NULL;
	if(!base){
		int len;
		s = (char*)MALLOC(MAX_FILEPATH);
		base = s;
		getcwd(s, MAX_FILEPATH);
		len = strlen(s);
		s[len] = SPLIT;
		s[len+1] = '\0';
	}
	abspath = fileio_abspath_ix(base, strlen(base)-1, relative, 0);
	if(s)
		FREE(s);
	return abspath;
}
