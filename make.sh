#!/bin/bash
cd bin
rm *.exe
cd ../lex
rm lex/*.c
cd ../src
rm *.tab.c
rm *.tab.h
rm *.yy.h
cd ..

clear
cd lex
bison --output ../src/65ca.tab.c -d 65ca.y
cd ../src
flex ../lex/65ca.l
gcc -o ../bin/65ca.exe *.c
cd ..
cat test/test.asm | bin/65ca.exe
