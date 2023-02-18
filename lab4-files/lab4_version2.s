.globl binary_search
binary_search:

//r0 = numbers, r1 = key, r2 = length, r4 = SWbase, r5 = keybase, r6 = LEDRbase 


//initial declarations
  MOV r8, #0 //startIndex gets 0

  SUB r3, r2, #1
  MOV r10, r3 //endIndex gets length - 1 

  MOV r9, r10, LSR #1 // middleIndex gets endIndex / 2

  MOV r12, #1 // numIters gets 1 

  MVN r11, #1 // keyIndex gets -1

//temporary registers: r3, r4, r5, r6

  MOV r3, #1 
  MVN r3, r3 //r3 gets -1

  whileLoop:

    //if startIndex > endIndex
    CMP r8, r10 //compares startIndex and endIndex
    BGT while_exit //if startIndex > endIndex, branch to exit

    LDR r5, [r0, r9, LSL #2]

    //if numbers[middleIndex == key]
    CMP r5, r1 //compares numbers[middleIndex] and key
    ITE EQ
    MOVEQ r11, r9 // keyIndex gets middleIndex
    BNE elseif

    elseif:
      MOV r3, #1
      MVN r3, r3 //r3 gets -1

      CMP r5, r1 //compares numbers[middleIndex] and the key
      ITE GT
      BGT if_GT
      BLT else

      if_GT:
        MOV r4, r9
        SUB r4, #1 // middleIndex - 1
        MOV r10, r4 //endIndex gets (middleIndex - 1)
        B exitif_GT
      exitif_GT:

    B elseif_exit

    elseif_exit:

    else:
      LDR r8, [r9, #4] //startIndex gets (middleIndex + 1) 
      B else_exit
    else_exit: 
    

    STR r7, [r0, r9, LSL #2] // temp r7 gets numbers[middleIndex] 
    RSB r3, r12, #0 // temp r3 gets negative numIters
    MOV r7, r3 // numbers[middleIndex] = -numIters 

    //middleIndex = startIndex + (endIndex - startIndex) / 2
    SUB r6, r10, r8 // stores endIndex - startIndex in temp reg r6
    MOV r3, r6, LSR #1
    ADD r9, r8, r3 // middleIndex gets sum of startIndex and r3

    ADD r12, r12, #1 // numIters++ do the subtraction thing instead?

    MOV r3, #1
    MVN r3, r3 //r13 gets -1 so that we can continue to compare keyIndex with -1

    CMP r11, r3 // while (keyIndex == -1)
    BEQ whileLoop //branch back to start of whileLoop

  while_exit:
MOV r0, r11
mov pc,lr


