#include <xc.h>

extern unsigned int multi_signed(unsigned char a,unsigned char b);

void main(void) {
    unsigned char a =127;
    unsigned char b =-6;
    volatile unsigned int res = multi_signed(a,b);
    while(1);
    return;
}
