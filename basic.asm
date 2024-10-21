#include "xc.inc"
GLOBAL _mysqrt
PSECT mytext,local,class=CODE,reloc=2
    
_mysqrt:
    MOVWF 0x010
    loop:
    INCF 0x000
    MOVF 0x000,w
    MULWF 0x000
    
    MOVFF PRODL,WREG
    CPFSLT 0x010 ;skip of 0x10<WREG
    GOTO loop 
   
    MOVFF 0x000,WREG
    
    RETURN
