#include "xc.inc"
GLOBAL _multi_signed
PSECT mytext,local,class=CODE,reloc=2
   
;TRISA =sign of result
;TRISB=sign of L=LATA
;TRISC=sign of L=LATC
;resultL=0x08    
;resultH=0x09
neg macro a3,sign
    MOVLW 0xFF;if negtive
    XORWF a3,F
    INCF a3
    MOVLW 0x80
    MOVWF sign
endm 
    
neg_unsign macro a3
    MOVLW 0xFF;if negtive
    XORWF a3,F
    INCF a3
 
endm 
    
_multi_signed:
MOVFF WREG,LATA
MOVFF 0x01,LATC

CLRF TRISC
CLRF TRISB
    
BTFSS LATC,7;4 bits
GOTO sign
neg LATC,TRISC

BTFSS LATA,7
GOTO sign
neg LATA,TRISB


    
sign:
MOVF TRISC,w
XORWF TRISB,w
MOVWF TRISA  
MOVLW 0x00
MOVWF 0x10;function i start with 0

;mul
CLRF 0x09
MOVFF LATA,0x11;cal low bits
function:
BTFSS LATC,0
GOTO noadd
MOVF 0x011,w
ADDWF 0x08,F;low
BNC nocarry
INCF 0x09
nocarry:
MOVFF LATA,0x12
MOVLW 0x08
MOVWF 0x14 
MOVF 0x10,w
SUBWF 0x14,W
MOVWF 0x13

loop:
MOVLW 0x00
CPFSGT 0x13
GOTO loopend
BCF 0x12,0    
RRNCF 0x12
DECF 0x13
GOTO loop      
loopend:;????
MOVF 0x12,w
ADDWF 0x09,F
    
noadd:
BCF 0x11,7    
RLNCF 0x11    
INCF 0x10
RRNCF LATC
MOVLW 0x04
CPFSEQ 0x10
GOTO function

MOVLW 0x80 ;b'10000000'
CPFSEQ TRISA
GOTO store
;if negtive    
MOVLW 0xFF
XORWF 0x09,w
MOVFF WREG,0x09
neg_unsign 0x08
BNC store
INCF 0x09
    
store:    
MOVFF 0x08,0x01;0x08 low byte
MOVFF 0x09,0x02;0x09 high byte


RETURN
