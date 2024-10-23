#include "xc.inc"
GLOBAL _mysqrt
PSECT mytext,local,class=CODE,reloc=2
    
_mysqrt:
    MOVWF 0x010
    loop:
    INCF 0x000
    MOVF 0x000,w
    MULWF 0x000
    
    MOVLW 0x00
    CPFSEQ PRODH
    GOTO loopend
    MOVFF 0x010,WREG
    CPFSLT PRODL ;skip of 0x10<WREG
    GOTO loopend
    GOTO loop
    
    loopend:
    MOVFF 0x000,WREG
    
    RETURN
