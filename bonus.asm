#include "xc.inc"
GLOBAL _multi_signed
PSECT mytext,local,class=CODE,reloc=2
   
;TRISA =sign of result
;TRISB=sign of FSR1L
;TRISC=sign of FSR2L
neg macro a3,sign
    MOVLW b'11111111';if negtive
    XORWF a3,F
    INCF a3
    MOVLW 0x80
    MOVWF sign
    endm 
    
_multi_signed:
MOVFF WREG,FSR1L
MOVFF 0x001,FSR2L

BTFSS FSR1L,7
GOTO sign
neg FSR1L,TRISB

BTFSS FSR2L,7
GOTO sign
neg FSR2L,TRISC
    
sign:
MOVF TRISC,w
XORWF TRISB,w
MOVWF TRISA  

MOVLW 0x01    
MOVWF 0x000;mask
function:
0x00
BTFSS FSR1L,0
CLRF BSR

RLNFS
    
    
RETURN
