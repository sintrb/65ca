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
win_bison --output ../src/65ca.tab.c -vd 65ca.y
cd ..\src
win_flex ..\lex\65ca.l
gcc -o ..\bin\65ca.exe *.c
cd ..
type test\test.na | bin\65ca.exe
