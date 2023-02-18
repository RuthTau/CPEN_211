.globl binary_search
binary_search:

 // 1st argument in R0 = numbers
 // 2nd argument in R1 = key 
 // 3rd argument in R2 = length

 @r3 is a pointer

 @r3,r4,r5,r6,r7

@  int startIndex = 0; startIndex = r8
MOV r8, #0

@  int endIndex = length - 1; endIndex = r9
SUB r9, r2, #1

@  int middleIndex = endIndex /2; middle index = r10
MOV r10, r9, LSR #1

@  int keyIndex = -1; keyIndex = r11
MOV r11, #-1

@  int NumIters = 1; NumIters r12
MOV r12, #1



@  while ( keyIndex == -1) {

while_Loop:

    @  if ( startIndex > endIndex )
    CMP r8,r9
    @ITE     GT
    BGT  while_Loop_exit
    @   break ;


@  else if ( numbers [ middleIndex ] == key ) , numbers is r0

    LDR r4, [r0,r10, LSL#2]
    CMP  r4, r1
    @ITTE EQ
    @  keyIndex = middleIndex 
    MOVEQ  r11, r10

@  else if ( numbers [ middleIndex ] > key ) {

    @ITE GT
    @  endIndex = middleIndex -1;
    SUBGT r9,r10,#1

@  } else {
    @  startIndex = middleIndex +1;
    ADDLT r8, r10, #1

    @ }


    @  numbers [ middleIndex ] = - NumIters ; NumIters = r12
        
        
    RSB r4, r12, #0
    STR r4, [r0,r10, LSL#2]

    @  middleIndex = startIndex + ( endIndex - startIndex )/2;
    SUB r7, r9,r8
    ADD r10, r8,r7, LSR #1

    @   NumIters ++;
    ADD r12, r12, #1
    

    MOV r7, #-1
    CMP r11, r7
    BEQ while_Loop
@  }
while_Loop_exit:

@  return keyIndex ;
MOV r0, r11
MOV pc,lr





