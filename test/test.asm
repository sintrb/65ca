.defseg name=ROM size=128    fill=#$00   start=$8000
.defseg name=VROM size=128    fill=#$00   start=$0000


.seg ROM

start:
ldy #$00
tya
sta $0000,y
iny
bne start

.info ROM
