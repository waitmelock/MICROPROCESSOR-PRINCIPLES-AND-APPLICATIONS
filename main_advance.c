#include <xc.h>

extern unsigned int gcd(unsigned int a,unsigned int b);

void main(void) {
    unsigned int a =1200;
    unsigned int b =180;
    volatile unsigned int result = gcd(a,b);
    while(1);
    return;
}
