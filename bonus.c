#include <xc.h>
#include <pic18f4520.h>
#include <stdio.h>
#include <stdlib.h>

#define _XTAL_FREQ 1000000  // 1 MHz

#pragma config OSC = INTIO67
#pragma config WDT = OFF    
#pragma config PWRT = OFF    
#pragma config BOREN = ON  
#pragma config PBADEN = OFF  
#pragma config LVP = OFF   

void PWM_Init() {
    T2CONbits.T2CKPS = 0b01; // 4
    PR2 = 249;               

    CCP1CONbits.CCP1M = 0b1100;
    CCPR1L = 0;                 
    CCP1CONbits.DC1B = 0;
    
    T2CONbits.TMR2ON = 1;    // TMR2 on
}

void ADC_Init() {
    ADCON1bits.VCFG0 = 0;   
    ADCON1bits.VCFG1 = 0;   
    ADCON1bits.PCFG = 0b1110; 
    ADCON0bits.CHS = 0b0000;  
    ADCON2bits.ADCS = 0b010;  
    ADCON2bits.ACQT = 0b010;  // 4 TAD
    ADCON2bits.ADFM = 0;     
    ADCON0bits.ADON = 1;     
}

void __interrupt(high_priority) H_ISR() {
    unsigned int value = ADRESH; 

    if(value==255){
        CCPR1L = 0;                 
        CCP1CONbits.DC1B = 0;
    }
    else{
        value=128-abs(value-128);
        unsigned int duty_cycle = value * 4;  // 256 to 1024
        CCPR1L = duty_cycle >> 2;             // high 8 
        CCP1CONbits.DC1B = duty_cycle & 0b11; // low 2
    }
    
    PIR1bits.ADIF = 0;

    ADCON0bits.GO = 1;
 
}

void main(void) {
    OSCCONbits.IRCF = 0b110; // 4 MHz

    TRISCbits.TRISC2 = 0;    // RC2=output
    PWM_Init();
    ADC_Init();

    PIE1bits.ADIE = 1;  
    PIR1bits.ADIF = 0; 
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1; 

    ADCON0bits.GO = 1;

    while (1) ;
}
