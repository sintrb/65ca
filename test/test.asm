.DEFINESEGMENT name=CODE size=128    fill=#$00   start=$8000



start:
lda #$12


ldx #$21


.org start
lda #$11




.info CODE
