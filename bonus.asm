#include "xc.inc"
GLOBAL _multi_signed
PSECT mytext,local,class=CODE,reloc=2
   
;TRISA =sign of result
;TRISB=sign of FSR1L
;TRISC=sign of FSR2L
neg macro a3,sign
    MOVLW 0xFF;if negtive
    XORWF a3,F
    INCF a3
    MOVLW 0x80
    MOVWF sign
endm 
    
neg_unsign macro a3,sign
    MOVLW 0xFF;if negtive
    XORWF a3,F
    INCF a3
    MOVLW 0x80
    MOVWF sign
endm 
    
_multi_signed:
MOVFF WREG,FSR1L
MOVFF 0x01,FSR2L
CLRF TRISB
CLRF TRISC
BTFSS FSR2L,7;4 bits
GOTO sign
neg FSR2L,TRISC

BTFSS FSR1L,7
GOTO sign
neg FSR1L,TRISB


    
sign:
MOVF TRISC,w
XORWF TRISB,w
MOVWF TRISA  

MOVLW 0x01    
MOVWF 0x00;mask
MOVLW 0x00
MOVWF 0x10;function i

;mul
CLRF FSR0H
MOVFF FSR1L,0x11;low bits
function:
RRNCF FSR2L 
BTFSS FSR2L,0
GOTO noadd
MOVF 0x011,w
ADDWF FSR0L,F
MOVFF 0x11,0x12
MOVFF 0x10,0x13

DECFSZ 0x13
RRNCF 0x12

MOVF 0x12,w
SUBWF FSR1L,w
ADDWF FSR0H
    
noadd:
BCF 0x11,7    
RLNCF 0x11    
INCF 0x10
MOVLW 0x03
CPFSEQ 0x10
GOTO function

    
    
MOVFF FSR0L,0x01
MOVFF FSR0H,0x02
    
RETURN
