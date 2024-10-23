#include "xc.inc"
GLOBAL _gcd
PSECT mytext,local,class=CODE,reloc=2
    
_gcd:
    MOVFF 0x001,0x10
    MOVFF 0x002,0x11
    MOVFF 0x003,0x20
    MOVFF 0x004,0x21
    
    ;make sure NO1>NO2
    MOVF 0x11,w
    CPFSEQ 0x21;if 2<1 skip
    GOTO compare
    MOVF 0x10,w
    CPFSGT 0x20;if B2>B1 skip
    GOTO function
    GOTO exchange
    compare:
    MOVF 0x11,w
    CPFSLT 0x21;if 2<1 skip
    GOTO exchange
    MOVF 0x11,w
    CPFSGT 0x21;if 2>1 skip
    GOTO function
    
    
    exchange:
    MOVFF 0x003,0x10
    MOVFF 0x004,0x11
    MOVFF 0x001,0x20
    MOVFF 0x002,0x21
    
    function:
    rcall DIV
    exchangeab: ;a=b,b=a%b
    MOVFF 0x10,0x003
    MOVFF 0x20,0x10
    MOVFF 0x003,0x20
    MOVFF 0x11,0x003
    MOVFF 0x21,0x11
    MOVFF 0x003,0x21
    ; check NO2==0
    MOVLW 0x00
    CPFSEQ 0x21;
    GOTO function
    MOVLW 0x00
    CPFSEQ 0x20;
    GOTO function
    GOTO functionend
    functionend:
    MOVFF 0x10,0x001
    MOVFF 0x11,0x002
    RETURN
    
    DIV:
    MOVF 0x20,w
    SUBWF 0x10,F ;1-2
    ;if high equal 
    MOVF 0x21,w
    CPFSEQ 0x11
    rcall checkcarry
    
    ;check if 1>2 GOTO DIV
    MOVF 0x21,w
    CPFSEQ 0x11;
    GOTO checkH
    MOVF 0x20,w
    CPFSLT 0x10 
    GOTO DIV
    GOTO DIVend
    checkH:
    MOVF 0x21,w
    CPFSLT 0x11;
    GOTO DIV
    DIVend:
    RETURN
   
    
    checkcarry:
    BC noneg
    DECF 0x11
    noneg:
    MOVF 0x21,w
    SUBWF 0x11,F ;1-2
    RETURN
