Sub_Mul marco xh, xl, yh, yl
;cal x-y
  MOVFF xh,0x00
  MOVF xl,w
  SUBWF yl,w
  MOVWF 0x01
  BC move2

  MOVLW b'11111111'
  SUBWF 0x01,F
  INCF 0x01
  DECF 0x00
  
  move2:
  MOVF 0x00,w
  SUBWF yh,w
  MOVWF 0x00
;
  MOVF 0x00,w
  MULWF 0x01
  MOVFF PRODH,0x10
  MOVFF PRODL,0x11
endm



setup:
MOVLW 0x0A
MOVWF 0x02;xh
MOVLW 0x04
MOVWF 0x03;xl
MOVLW 0x04
MOVWF 0x04;yh
MOVLW 0x02
MOVWF 0x05;yl

Sub_Mul 0x02,0x03,0x04,0x05

