#include <xc.h>

extern unsigned char mysqrt(unsigned char a);

void main(void) {
    volatile unsigned char result = mysqrt(20);
    while(1);
    return;
}
