#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x10 	
MOVLW 0x12;
MOVWF 0x00
MOVLW 0xCB;
MOVWF 0x01
	
MOVLW 0x09;
MOVWF 0x10
MOVLW 0x35;
MOVWF 0x11

MOVF 0x11,w
MULWF 0x01	
MOVFF PRODL,0x23
MOVFF PRODH,0x22
	
MOVF 0x11,w	
MULWF 0x00
MOVF PRODL,w	
ADDWF 0x22,w
MOVWF 0x22
BNC noover
INCF 0x21
	
noover:
MOVF PRODH,w
ADDWF 0x21	
	
    
MOVF 0x10,w	
MULWF 0x01
MOVF PRODL,w	
ADDWF 0x22,w
MOVWF 0x22    
BNC noover1
INCF 0x21

noover1:    
MOVF PRODH,w
ADDWF 0x21,F

MOVF 0x10,w		
MULWF 0x00
MOVF PRODL,w	
ADDWF 0x21,w
MOVWF 0x21
BNC noover2
INCF 0x20

noover2:
MOVF PRODH,w
ADDWF 0x20	
end


