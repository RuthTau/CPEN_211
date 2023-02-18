.globl binary_search
binary_search:

 // 1st argument in R0 = numbers
 // 2nd argument in R1 = key 
 // 3rd argument in R2 = length 

 SUB r4,r2,#1

 MOV r2, #0

 MOV r3,r2, LSR #1

 MOV r5, #-1

 MOV r6, #1

 Loop:
    CMP r2, r4
    BGT exit

    LDR r7, [r0,r3,LSL#2]

    CMP r7,r1
    MOVEQ r5,r3
    SUBGT r4,r3,#1
    ADDLT r2,r3,#1

    RSB r7, r6,#0
    STR r7, [r0,r3,LSL #2]

    SUB r8,r4,r2
    ADD r3,r2,r8,LSR #1
    ADD r6,r6,#1

    B Loop

exit:
    MOV r0,r5
    MOV pc, lr



    //check value input match : r1 return the value or r7
    //check memory with that address in r1, front and bk see if match list