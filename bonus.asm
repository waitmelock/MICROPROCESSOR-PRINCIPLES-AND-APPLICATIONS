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
MOVWF 0x10;function i

;mul
CLRF 0x09
MOVFF LATA,0x11;low bits
function:
RRNCF LATC 
BTFSS LATC,0
GOTO noadd
MOVF 0x011,w
ADDWF 0x08,F
MOVFF 0x11,0x12
MOVFF 0x10,0x13

loop:
MOVLW 0x00
CPFSGT 0x13
GOTO loopend
RRNCF 0x12
DECF 0x13
GOTO loop    
    
loopend:
MOVF 0x12,w
SUBWF LATA,w
ADDWF 0x09
    
noadd:
BCF 0x11,7    
RLNCF 0x11    
INCF 0x10
MOVLW 0x03
CPFSEQ 0x10
GOTO function

MOVLW 0x80
CPFSEQ TRISA
GOTO store
    
MOVLW 0xFF;if negtive
XORWF 0x09,w
MOVFF WREG,0x09
neg_unsign 0x08
BNC store
INCF 0x09
    
store:    
MOVFF 0x08,0x01
MOVFF 0x09,0x02
    
RETURN
