#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x10 ;PC = 0x10 	
setup:
    LFSR 0, 0x100;key 
    LFSR 1, 0x100;j 
    LFSR 2, 0x100;temp pointer
    
setup1:
    MOVLB 0x1
    MOVLW 0x08
    MOVWF 0x00,1
    MOVLW 0x7C
    MOVWF 0x01,1
    MOVLW 0x78 
    MOVWF 0x02,1
    MOVLW 0xFE
    MOVWF 0x03,1
    MOVLW 0x34
    MOVWF 0x04,1
    MOVLW 0x7A
    MOVWF 0x05,1
    MOVLW 0x0D
    MOVWF 0x06,1
start:
    MOVLW 0x07
    MOVWF 0x00;len of arr
    MOVLW 0x00
    MOVWF 0x02;cal the boundary
    ;LFSR 0, 0x100;key 
    ;LFSR 1, 0x100;j 
    ;LFSR 2, 0x100;temp pointer
    
sorting:  
    MOVF 0x02,w
    SUBWF 0x00,w
    MOVWF 0x01;len of unsorted
   
    keycom:    
    MOVF PREINC2,w
    CPFSGT INDF0
    GOTO notchange
    MOVF FSR2L, W    ; WREG = FSR0L (取得新低位地址)
    MOVWF FSR0L  ; 將新地址賦值給 FSR1L
    MOVF FSR2H, W    ; WREG = FSR0H (取得高位地址)
    MOVWF FSR0H     ; 將高位地址賦值給 FSR1H
    notchange:
    DECFSZ 0x01
    GOTO keycom

    MOVF INDF1,w
    MOVFF INDF0,INDF1
    MOVWF POSTINC1  ;after switch, j++
    INCF 0x02
    
    CPFSGT 0x07
    GOTO sorting
    
end    

    
    
    
  


