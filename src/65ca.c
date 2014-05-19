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
	while((ch=getopt(argc,argv,"vho:"))!=-1) {
		switch(ch){
			case '?':
				// unknow
				fprintf(stderr, "unknown option: %c\n", optopt);
				exit(1);
				break;
			case 'o':
				// output file
				outfile = str_clone(optarg);
				break;
			case 'h':
				// help
				printf("usage: %s [-h] -o outfile infile\n\t-h, help information, show this page\n\t-o outfile, the output binary file, 6502 machine code\n\tinfile, the input file, assembly source code\n", argv[0]);
				exit(0);
				break;
			case 'v':
				// version
				printf("%s\n", VERSION_S);
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
	printf("%s-->65ca-->%s\n", infile, outfile);
	exit(0);
	init();
	yyparse();
	destory();
	FREE(infile);
	FREE(outfile);
	printf("compile success!!!\n");
	return 0;
}



