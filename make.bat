
# clean >>log.null 2>&1

cd lex
win_bison --output ../src/65ca.tab.c -vd 65ca.y
cd ..\src
win_flex ..\lex\65ca.l
gcc -lm -o ..\bin\65ca.exe *.c
cd ..
type test\test.na | bin\65ca.exe
