#include <xc.h>
#include <pic18f4520.h>
#include <stdio.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON    // Brown-out Reset Enable bit
#pragma config PBADEN = OFF  // Watchdog Timer Enable bit
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)


void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = ADRESH;

    //do things
    
    switch(value){
        case 4:
            LATB = 0x06; 
            break;
        case 36:
            LATB = 0x04; 
            break;
        case 68:
            LATB = 0x01; 
            break;
        case 100:
            LATB = 0x00; 
            break;
        case 132:
            LATB = 0x01; 
            break;
        case 164:
            LATB = 0x00; 
            break;
        case 196:
            LATB = 0x03; 
            break;
        case 228:
            LATB = 0x02; 
            break;
        default :
            break;
    }
   
    //clear flag bit
    PIR1bits.ADIF = 0;

    //step5 & go back step3
    //delay at least 2tad
    ADCON0bits.GO = 1;
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; //1MHz
    TRISAbits.RA0 = 1;       //analog input port
    TRISB =  0b11110000;       //analog input port
    LATB = 0x00; 
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 為analog input,其他則是 digital
    ADCON0bits.CHS = 0b0000;  //AN0 當作 analog input
    ADCON2bits.ADCS = 0b000;  //查表後設000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time設2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;


    //step3
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}
