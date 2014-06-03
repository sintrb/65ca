.defseg name=ROM size=128    fill=#$00   start=$8000


.inc "inc\inc1.asm"

.incbin "about.txt"

.info ROM

