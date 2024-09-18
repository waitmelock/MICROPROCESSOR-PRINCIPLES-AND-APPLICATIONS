List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
MOVLW 0x07 ;
MOVWF 0x00
MOVLW 0x09 ;
MOVWF 0x01
ADDWF 0x00,W	
MOVWF 0x02
	
MOVLW 0x12 ;
MOVWF 0x10
MOVLW 0x01 ;
MOVWF 0x11
SUBWF 0x10,W	
MOVWF 0x12

CPFSEQ 0x02
    GOTO test2
    MOVLW 0xBB 
    GOTO testend
test2:
CPFSGT 0x02
    GOTO test3
    MOVLW 0xAA 
    GOTO testend 

test3:
    MOVLW 0xCC 
    
testend:
MOVWF 0x20
    
end
