#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x10 ;PC = 0x10 	
setup:
    LFSR 0, 0x100 ;arr
    
setup1:
    MOVLB 0x1
    MOVLW 0xFF
    MOVWF 0x00,1
    MOVLW 0x87
    MOVWF 0x01,1
    MOVLW 0x8C 
    MOVWF 0x02,1
    MOVLW 0xEF
    MOVWF 0x03,1
    MOVLW 0x43
    MOVWF 0x04,1
    MOVLW 0xA7
    MOVWF 0x05,1
    MOVLW 0xD1
    MOVWF 0x06,1
start:
    MOVLW 0x07
    MOVWF 0x00 ;n
    MOVLW 0x00
    MOVWF 0x01; i
    ;0x02= j
    ;0x03= min
    ;0x04=temp in check
    
    ;for (i = 0; i < n-1; i++)
    ;{
        ;min_idx = i;
        ;for (j = i+1; j < n; j++)
        ;  if (arr[j] < arr[min_idx])
        ;    min_idx = j;

        ;   if(min_idx != i)
        ;    swap(arr[min_idx], arr[i]);
    ;}
    
sorting:  
    MOVFF 0x01,0x03
    
    MOVFF 0x01,0x02
    INCF 0x02
compare:
    MOVF 0x02,w 
    MOVF PLUSW0,w
    MOVWF 0x04
    MOVF 0x03,w
    MOVF PLUSW0,w
    CPFSLT 0x04 ;arr[j]<
    GOTO nonew
    MOVFF 0x02,0x03
    nonew:

    INCF 0x02
    MOVLW 0x07
    CPFSEQ 0x02 ;0x00<0x07 then skip GOTO
    GOTO compare
    
    ;if(min_idx != i)
    MOVF 0x01,w
    CPFSEQ 0x03
    GOTO swap
    GOTO noswap
    
    swap:
    MOVF 0x01,w 
    MOVF PLUSW0,w
    MOVWF 0x04
   
    MOVF 0x03,w
    MOVF PLUSW0,w
    MOVWF 0x05
    
    MOVF 0x03,w
    MOVFF 0x04,PLUSW0
    MOVF 0x01,w
    MOVFF 0x05,PLUSW0
    noswap:
    
    
    
    INCF 0x01
    MOVLW 0x06
    CPFSEQ 0x01 ;0x00>0x07 then skip GOTO
    GOTO sorting
    
    
    CLRF 0x00
    CLRF 0x01
    CLRF 0x02
    CLRF 0x03
    CLRF 0x04
    CLRF 0x05
    
end    

    
    
    
  
