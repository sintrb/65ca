.defseg name=ROM size=128    fill=#$00   start=$8000
.defseg name=VROM size=128    fill=#$00   start=$0000


start:
lda #$12
ldx #$21
lda #$11

.seg VROM
lda #$78



.info ROM
.info VROM
