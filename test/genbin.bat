del test.nesa test.65ca
type test.asm | ..\bin\65ca.exe
rename output.bin test.65ca
nesa.exe -o test.nesa test.na


echo ok, compare test.65ca with test.nesa

pause