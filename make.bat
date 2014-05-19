cd bin
del *.exe
cd ..\lex
del lex\*.c
cd ..\src
del *.tab.c
del *.tab.h
del *.yy.h
cd ..

cls
cd lex
win_bison --output ../src/65ca.tab.c -d 65ca.y
cd ..\src
win_flex ..\lex\65ca.l
gcc -o ..\bin\65ca.exe *.c
cd ..
REM type test\test.asm | bin\65ca.exe

bin\65ca.exe test\test.asm
