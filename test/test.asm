.defseg name=ROM size=128    fill=#$00   start=$8000
.defseg name=VROM size=128    fill=#$00   start=$0000


lda lab
sta lab
jmp lab



.info ROM
.info VROM
.info lab