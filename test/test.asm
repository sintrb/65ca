.defseg name=ROM size=128    fill=#$00   start=$8000
.defseg name=VROM size=128    fill=#$00   start=$0000


.seg ROM

start:
ldy #$00
tya
sta $0000,y
iny
bne start

<<<<<<< HEAD
lda abc
lda abc
lda abc
lda abc


.info ROM

.info abc
=======

.dat 1 2 3 4 nmi rest irq

nmi=$1234
rest=$5678
irq=$8899

.info ROM
>>>>>>> 9cc14b203a902ef63ee75d72928cf524203d08f8
