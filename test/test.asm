.org $2000
lda ($4e, x)
lda $ed
lda #$28
lda $ff55
lda ($ae), y

loop:
lda 212
lda %00110011

JMP	(loop)

JMP loop

.lab t = $1234
.lab td= %11000010
lda t

lda td


.lab tdd= %11000010
lda 128319823

jsr ttt

.lab ttt=21
jsr ttt