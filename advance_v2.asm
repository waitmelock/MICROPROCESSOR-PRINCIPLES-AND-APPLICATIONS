;0x10-0x13 xh,xl,yh,yl
;0x14-0x19
;0x00-0x05 variable
;0x06 first sign 
;0x07 second sign 
;0x08 after mul
;sub_mul macro x,y
#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x00 ;PC = 0x10     
	
; 二的補數表示法 算sign 
neg macro a3,sign
    MOVLW b'11111111';if negtive
    XORWF a3,F
    INCF a3
    MOVLW 0x01
    MOVWF sign
    endm 
neg_nosign macro a3
    MOVLW b'11111111';if negtive
    XORWF a3,F
    INCF a3
    endm 
sign_mul macro a3,b1,store
    MOVF 0x06,w
    XORWF 0x07
    MOVWF store
    MOVF a3,w
    MULWF b1
    endm
var macro a1,b1,a2,b2
    MOVFF a1,0x02
    MOVFF b1,0x03
    MOVFF a2,0x00
    MOVFF b2,0x05   
 endm
 

    
setup:
MOVLW 0x0B;
MOVWF 0x14;a1
MOVLW 0x00;
MOVWF 0x15;a2
MOVLW 0x10;
MOVWF 0x16;a3
MOVLW 0x0C;
MOVWF 0x17;b1
MOVLW 0x00;
MOVWF 0x18;b2
MOVLW 0x06;
MOVWF 0x19;b3

program:
var 0x15,0x19,0x16,0x18 
rcall cross
MOVFF 0x30,0x20
    
var 0x16,0x17,0x14,0x19 
rcall cross
MOVFF 0x30,0x21
    
var 0x14,0x18,0x15,0x17 
rcall cross
MOVFF 0x30,0x22
    
GOTO final    
    
cross:
; first set
CLRF 0x06
CLRF 0x07
BTFSS 0x02,7 ;if <0 do neg
GOTO pos1
  neg 0x02,0x06
pos1:
BTFSS 0x03,7
GOTO pos2
  neg 0x03,0x07
pos2:
  sign_mul 0x02,0x03,0x08

MOVFF PRODH,0x10
MOVFF PRODL,0x11
  
CLRF 0x31
MOVLW 0x01  
CPFSEQ 0x08
GOTO posend
MOVLW b'11111111';if negtive
XORWF 0x11,F
INCF 0x11
BNC upupno
MOVLW 0x01  
MOVWF 0x31
upupno:
MOVLW b'11111111';if negtive
XORWF 0x10,F
MOVF 0x31,w
ADDWF 0x10,F
   
posend:
    
;second set
CLRF 0x06
CLRF 0x07
BTFSS 0x00,7
GOTO pos21
  neg 0x00,0x06
pos21:
BTFSS 0x05,7
GOTO pos22
  neg 0x05,0x07
pos22:
  sign_mul 0x00,0x05,0x09

MOVFF PRODH,0x12
MOVFF PRODL,0x13
  
CLRF 0x31  
MOVLW 0x00  
CPFSEQ 0x09
GOTO posend2
MOVLW b'11111111';if negtive
XORWF 0x13,F
INCF 0x13
BNC upupno1
MOVLW 0x01  
MOVWF 0x31
upupno1:
MOVLW b'11111111';if negtive
XORWF 0x12,F
MOVF 0x31,w
ADDWF 0x12,F   
posend2:  
    

MOVF 0x11,w
ADDWF 0x13,w
MOVWF 0x30
  
crossend:
RETURN
final:
    
end


