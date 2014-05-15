start:

lda #$00
ldy #$00
loop:
sta $0000,y
tya
bne loop

