#include <xc.h>
#include <pic18f4520.h>

#define _XTAL_FREQ 125000  // 定義內部振盪器頻率為 125 kHz
#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single-supply) In-Circuit Serial Programming Enable bit
#pragma config CPD = OFF        // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)

void setServoAngle(int angle)
{ /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8µs * 4
     * = 0.00144s ~= 1450µs
     */
    switch (angle) {
        case -90:  // -90° → 500 µs
            CCPR1L = 0x03;
            CCP1CONbits.DC1B = 0b11;
            break;
        case 0:    // 0° → 1450 µs
            CCPR1L = 0x0b;
            CCP1CONbits.DC1B = 0b01;
            break;
        case 90:   // +90° → 2400 µs
            CCPR1L = 0x12;
            CCP1CONbits.DC1B = 0b11;
            break;
        default:   // 預設維持當前位置
            break;
    }
}

void main(void)
{
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    OSCCONbits.IRCF = 0b001;
    
    // PWM mode, P1A active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
        // Configure PORTB as input for RB0 and enable pull-up resistors
    TRISB = 0x01;     // RB0 as input
    LATB = 0;
    // Set up PR2, PWM period = 20ms
    PR2 = 0x9B;
    
    setServoAngle(-90);  // 設定到 -90°
    while (1)
    {
        // Check if button is pressed
        if (PORTBbits.RB0 == 0) {  // Active low button
            __delay_ms(500);        // Debounce delay
             setServoAngle(-90);  // 設定到 -90°
            __delay_ms(500);   // 等待 0.5 秒
            setServoAngle(0);    // 設定到 0°
            __delay_ms(500);   // 等待 0.5 秒
            setServoAngle(90);   // 設定到 +90°
            __delay_ms(500);   // 等待 0.5 秒
        }
        setServoAngle(-90);  // 設定到 -90°
    }
}
