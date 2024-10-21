#include "xc.inc"
GLOBAL _gcd
PSECT mytext,local,class=CODE,reloc=2
    
_gcd:
    MOVFF 0x001,FSR1L
    MOVFF 0x002,FSR1H
    MOVFF 0x003,FSR2L
    MOVFF 0x004,FSR2H
    
    MOVF FSR1H,w
    CPFSLT FSR2H;if 2<1 skip
    GOTO exchange
    MOVF FSR1H,w
    CPFSGT FSR2H;if 2>1 skip
    GOTO function
    MOVF FSR1L,w
    CPFSGT FSR2L;if 2>1 skip
    GOTO function
    
    exchange:
    MOVFF 0x003,FSR1L
    MOVFF 0x004,FSR1H
    MOVFF 0x001,FSR2L
    MOVFF 0x002,FSR2H
    
    function:
    rcall DIV
    exchangeab: ;a=b,b=a%b
    MOVFF FSR1L,0x003
    MOVFF FSR2L,FSR1L
    MOVFF 0x003,FSR2L
    MOVFF FSR1H,0x003
    MOVFF FSR2H,FSR1H
    MOVFF 0x003,FSR2H
    ; check FSR2==0
    MOVLW 0x00
    CPFSEQ FSR2H;
    GOTO function
    MOVLW 0x00
    CPFSEQ FSR2L;
    GOTO function
    GOTO functionend
    functionend:
    MOVFF FSR1L,0x001
    MOVFF FSR1H,0x002
    RETURN
    
    DIV:
    MOVF FSR2L,w
    SUBWF FSR1L,F ;1-2
    ;if high equal 
    MOVF FSR2H,w
    CPFSEQ FSR1H
    rcall checkcarry
    ;check if 1>2 GOTO DIV
    MOVF FSR2H,w
    CPFSEQ FSR1H;
    GOTO checkH
    MOVF FSR2L,w
    CPFSLT FSR1L 
    GOTO DIV
    GOTO DIVend
    checkH:
    MOVF FSR2H,w
    CPFSLT FSR1H;
    GOTO DIV
    DIVend:
    RETURN
    
    checkcarry:
    BC noneg
    DECF FSR1H
    noneg:
    MOVF FSR2H,w
    SUBWF FSR1H,F ;1-2
    RETURN
