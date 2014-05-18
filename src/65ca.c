/**
65ca.c
Robin 2014-05-07
**/

#include "define.h"
#include "functions.h"
#include <unistd.h>
int yyparse ();

int main(int argc, char *argv[])
{
	char ch;
	opterr = 0;
	while((ch=getopt(argc,argv,"ho:"))!=-1) {
		switch(ch){
			case '?':
				fprintf(stderr, "unknown option: %c\n", optopt);
				break;
			case 'o':
				outfile = str_clone(optarg);
				break;
			case 'h':
				printf("usage: %s [-h] -o outfile infile\n\t-h, help information, show this page\n\t-o outfile, the output binary file, 6502 machine code\n\tinfile, the input file, assembly source code\n", argv[0]);
				exit(0);
				break;
		}
	}
	if(optind < argc){
		infile = str_clone(argv[optind]);
	}
	if(!infile){
		fprintf(stderr, "%s: no input file, -h show help\n", argv[0]);
		exit(1);
	}
	if(!outfile){
		outfile = (char*)MALLOC(256);
		sprintf(outfile, "%s.bin", infile);
	}
	printf("%s->65ca->%s\n", infile, outfile);
	init();
	yyparse();
	destory();
	FREE(infile);
	FREE(outfile);
	printf("compile success!!!\n");
	return 0;
}



