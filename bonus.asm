#include "xc.inc"
GLOBAL _multi_signed
PSECT mytext,local,class=CODE,reloc=2
   
;TRISA =sign of result
;TRISB=sign of L=0x15
;TRISC=sign of L=0x16
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
MOVFF WREG,0x15;100=10011100
MOVFF 0x001,0x16

CLRF TRISC
CLRF TRISB    
         
    
MOVLW 0x80
CPFSEQ 0x15
GOTO not801
MOVLW 0x80
MOVWF TRISB 
GOTO not8016
not801:      
BTFSS 0x15,7
GOTO sign
neg 0x15,TRISB

not8016:
MOVLW 0x80
CPFSEQ 0x16
GOTO not802
MOVLW 0x80
MOVWF TRISC
GOTO not80end
not802:
BTFSS 0x16,7;4 bits
GOTO sign
neg 0x16,TRISC
not80end:
    
sign:
MOVF TRISC,w
XORWF TRISB,w
MOVWF TRISA  
MOVLW 0x00
MOVWF 0x10;function i start with 0

;mul
CLRF 0x09
MOVFF 0x15,0x11;cal low bits
function:
BTFSS 0x16,0
GOTO noadd
MOVF 0x011,w
ADDWF 0x08,F;low
BNC nocarry
INCF 0x09
nocarry:
MOVFF 0x15,0x12
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
RRNCF 0x16
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
