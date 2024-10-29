LIST p=18f4520
#include<p18f4520.inc>

    CONFIG OSC = INTIO67 ; Set internal oscillator to 1 MHz
    CONFIG WDT = OFF     ; Disable Watchdog Timer
    CONFIG LVP = OFF     ; Disable Low Voltage Programming

    L1 EQU 0x14         ; Define L1 memory location
    L2 EQU 0x15         ; Define L2 memory location
    org 0x00            ; Set program start address to 0x00
;187500=0.75s 

; instruction frequency = 1 MHz / 4 = 0.25 MHz
; instruction time = 1/0.25 = 4 ?s
;250000=1s=111,249
; Total_cycles = 4 + (2 +  9* num1 + 3) * num2 cycles     
; DELAY10 d'111', d'249' 
;125000=0.5s=
; Total_cycles = 5 + (3 +  5* num1 + 3) * num2 cycles     
; DELAY05 d'127', d'195'

DELAY10 macro num1, num2;
    local LOOP1         ; Inner loop
    local LOOP2         ; Outer loop
    NOP
    NOP
    
    ; 2 cycles
    MOVLW num2          ; Load num2 into WREG
    MOVWF L2            ; Store WREG value into L2
    NOP
    
    ; Total_cycles for LOOP2 = 2 cycles
    LOOP2:
    MOVLW num1          
    MOVWF L1  
    
    ; Total_cycles for LOOP1 = 8 cycles
    LOOP1:
    NOP                 ; busy waiting
    NOP
    NOP
    NOP
    NOP
    NOP
    DECFSZ L1, 1        
    BRA LOOP1           ; BRA instruction spends 2 cycles
    
    ; 3 cycles
    DECFSZ L2, 1        ; Decrement L2, skip if zero
    BRA LOOP2           
endm
DELAY05 macro num1, num2;DELAY05 d'127', d'195'
    local LOOP1         ; Inner loop
    local LOOP2         ; Outer loop

    ; 2 cycles
    MOVLW num2          ; Load num2 into WREG
    MOVWF L2            ; Store WREG value into L2
    NOP
    NOP
    NOP
    
    ; Total_cycles for LOOP2 = 2 cycles
    LOOP2:
    MOVLW num1          
    MOVWF L1  
    NOP
    ; Total_cycles for LOOP1 = 5 cycles
    LOOP1:
    NOP                 ; busy waiting
    NOP
    DECFSZ L1, 1        
    BRA LOOP1           ; BRA instruction spends 2 cycles
    
    ; 3 cycles
    DECFSZ L2, 1        ; Decrement L2, skip if zero
    BRA LOOP2           
endm
    
int:
; let pin can receive digital signal
    MOVLW 0x0f          ; Set ADCON1 register for digital mode
    MOVWF ADCON1        ; Store WREG value into ADCON1 register
    CLRF PORTB          ; Clear PORTB
    BSF TRISB, 0        ; Set RB0 as input (TRISB = 0000 0001)
    CLRF LATA           ; Clear LATA
    BCF TRISA, 0        ; Set RA0 as output (TRISA = 0000 0000)
    BCF TRISA, 1        
    BCF TRISA, 2     

    
start: 
; Button check
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA start   ; If button is not pressed, branch back to check_process
state1:    
    CLRF LATA 
    BTG LATA, 0         ; Toggle RA0 state (change LED state)
   DELAY05 d'127', d'195' ; Call delay macro to delay for about 0.25 seconds
    
    CLRF LATA 
    BTG LATA, 1         ; Toggle RA0 state (change LED state)
    DELAY05 d'127', d'195' ; Call delay macro to delay for about 0.25 seconds
     
    CLRF LATA 
    BTG LATA, 2         ; Toggle RA0 state (change LED state)
    DELAY05 d'127', d'195' ; Call delay macro to delay for about 0.25 seconds
    
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA state1   ; If button is not pressed, branch back to check_process
    
state2:
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
    BRA state2   ; If button is not pressed, branch back to check_process
    
    CLRF LATA 
    BTG LATA, 0         ; Toggle RA0 state (change LED state)
    DELAY10 d'111', d'249'  ; Call delay macro to delay for about 0.25 seconds
    
    CLRF LATA 
    BTG LATA, 1         ; Toggle RA0 state (change LED state)
    DELAY10 d'111', d'249'  ; Call delay macro to delay for about 0.25 seconds
     
    CLRF LATA 
    BTG LATA, 2         ; Toggle RA0 state (change LED state)
    DELAY10 d'111', d'249' ; Call delay macro to delay for about 0.25 seconds
    BTFSS PORTB, 0      ; Check if PORTB bit 0 is high (button pressed)
    BRA state2   ; If button ispressed, branch back to state1
end







