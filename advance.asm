List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
CLRF 0x02
MOVLW 0xFF ;
MOVWF 0x00
MOVLW 0X1E ;
MOVWF 0x01
    
; ?????????????bit
MOVLW b'11110000'
ANDWF 0x00, W
ADDWF 0x02
    
MOVLW b'00001111'
ANDWF 0x01, W
ADDWF 0x02
    
; 
MOVLW 0x09
MOVWF 0x04
COMF 0x02, W ;complement of 0x02
MOVWF 0x05 ; temp complement of 0x02 
; not =0 
again:
    DCFSNZ 0x04 ;i of loop 
	GOTO againend
	MOVLW  b'00000001'
	ANDWF 0x05,W
	ADDWF 0x03
	RRNCF 0x05
	GOTO again
againend:	
  CLRF 0x05
  CLRF 0x04
end
