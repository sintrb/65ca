.defseg name=ROM size=128    fill=#$00   start=$8000
.defseg name=VROM size=128    fill=#$00   start=$0000


.seg ROM

start:
ldy #$00
tya
sta $0000,y
iny
bne start


.dat 1 2 3 4 nmi rest irq

nmi=$1234
rest=$5678
irq=$8899

.info ROM