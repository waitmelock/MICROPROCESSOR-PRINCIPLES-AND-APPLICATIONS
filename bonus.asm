#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x10 	

    
MOVLW 0xFF;
MOVWF 0x00
MOVLW 0xF1;
MOVWF 0x01
	
MOVLW b'11111110'
MOVWF 0x04; find ???
CLRF 0x02

MOVLW 0x00	
CPFSEQ 0x00
GOTO loop2 ;=0 dont go to loop2
	
MOVFF 0x01,0x03    


loop1: ;8 UNDER
MOVLW b'11111110'
ANDWF 0x03,F
RRNCF 0x03
RLNCF 0x04 ;
INCF 0x02  
MOVLW 0x02
CPFSLT 0x03
GOTO loop1
; if have value
MOVF 0x01,w
ANDWF 0x04,f
MOVLW 0x00
CPFSEQ 0x04
INCF 0x02
GOTO endloop 
    
loop2:
MOVFF 0x00,0x05 ; copy
MOVLW 0x08 ;+8
MOVWF 0x02
loop22:
MOVLW b'11111110'
ANDWF 0x05,F
RRNCF 0x05
RLNCF 0x04
INCF 0x02  
MOVLW 0x02
CPFSLT 0x05
GOTO loop22
MOVF 0x00,w
ANDWF 0x04,f ;?????
MOVLW 0x00
CPFSEQ 0x04
INCF 0x06 ;0x01?0x00???????

CPFSEQ 0x01
INCF 0x06

CPFSEQ 0x06 ;??++
INCF 0x02
    
endloop:

CLRF 0x03
CLRF 0x04
CLRF 0x05
CLRF 0x06
end




