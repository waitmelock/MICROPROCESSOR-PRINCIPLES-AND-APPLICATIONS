#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x10 	
Sub_Mul macro xh, xl, yh, yl
;cal x-y
  MOVFF xh,0x00
  MOVF yl,w
  SUBWF xl,w ;F-w
  MOVWF 0x01
  BC move2
  
  DECF 0x00
  
  move2:
  MOVF yh,w
  SUBWF 0x00,w
  MOVWF 0x00
;
  MOVF 0x00,w
  MULWF 0x01
  MOVFF PRODH,0x10
  MOVFF PRODL,0x11
endm

setup:
MOVLW 0x03
MOVWF 0x02;xh
MOVLW 0xA5
MOVWF 0x03;xl
MOVLW 0x02
MOVWF 0x04;yh
MOVLW 0xA7
MOVWF 0x05;yl

Sub_Mul 0x02,0x03,0x04,0x05
   

end

