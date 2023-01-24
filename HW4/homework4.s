/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 4 Part 5
*/
		.text
		.equ HEX0,     0x202070 /* Address of HEX0 */
        .equ HEX1,     0x202060 /* Address of HEX1 */
        .equ HEX2,     0x202050 /* Address of HEX2 */
        .equ HEX3,     0x202040 /* Address of HEX3 */
        .equ HEX4,     0x202090 /* Address of HEX4 */
        .equ HEX5,     0x202080 /* Address of HEX5 */

        .equ HEX_ZERO,  0b11000000 /* 0 for Seven-Segment Display */ 
        .equ HEX_ONE,   0b11111001 /* 1 for Seven-Segment Display */
        .equ HEX_TWO,   0b10100100 /* 2 for Seven-Segment Display */
        .equ HEX_THREE, 0b10110000 /* 3 for Seven-Segment Display */ 
        .equ HEX_FOUR,  0b10011001 /* 4 for Seven-Segment Display */
        .equ HEX_FIVE,  0b10010010 /* 5 for Seven-Segment Display */
        .equ HEX_SIX,   0b10000010 /* 6 for Seven-Segment Display */
        .equ HEX_SEVEN, 0b11111000 /* 7 for Seven-Segment Display */
        .equ HEX_EIGHT, 0b10000000 /* 8 for Seven-Segment Display */
        .equ HEX_NINE,  0b10011000 /* 9 for Seven-Segment Display */

        .global _start /* Beginning of program */

_start:
        /* 
           7-Segment Displays are common anode, must write 1 to 
           turn off each segment
        */
HEXOFF:
        movi  r15,0x7F /* Value to turn off 7-segment display */
        movia r16,HEX0 /* Load address of HEX0 */
        stwio r15,0(r16) /* Turn off HEX0 */
        movia r16,HEX1 /* Load address of HEX1 */
        stwio r15,0(r16) /* Turn off HEX1 */
        movia r16,HEX2 /* Load address of HEX2 */
        stwio r15,0(r16) /* Turn off HEX2 */
        movia r16,HEX3 /* Load address of HEX3 */
        stwio r15,0(r16) /* Turn off HEX3 */
        movia r16,HEX4 /* Load address of HEX4 */
        stwio r15,0(r16) /* Turn off HEX4 */
        movia r16,HEX5 /* Load address of HEX5 */
        stwio r15,0(r16)  /* Turn off HEX5 */

        mov   r10,r0 /* Initialize r10 to zero (consecutive 1's) */
        mov   r11,r0 /* Initialize r11 to zero (consective 0's) */
        mov   r12,r0 /* Initialize r12 to zero (alternating 10) */
       
        movia r17,TEST_NUM /* Move TEST_NUM address to r17 */
        movia r18,XOR1 /* Move XOR_TEST1 address to r18 */
        movia r19,XOR2 /* Move XOR_TEST2 address to r19 */
        ldw   r18,(r18) /* Load value for first XOR test */
        ldw   r19,(r19) /* Load value for second XOR test */
TOP1:   ldw   r4,(r17) /* Load TEST_NUM */
        beq   r4,r0,NEXT_ZEROS /* If TEST_NUM == 0, end program */
        call  ONES /* Call ONES subroutine */
        addi  r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt   r2,r10,STORE1 /* If new max > old max, store new max */
        br    TOP1 /* Load TEST_NUM */
STORE1: mov   r10,r2 /* Store new max to r10 */
        br    TOP1 /* Load TEST_NUM */

NEXT_ZEROS:

        movia r17,TEST_NUM /* Move TEST_NUM address to r17 */
TOP2:   ldw   r4,(r17) /* Load TEST_NUM */
        beq   r4,r0,XOR_TEST1 /* If TEST_NUM == 0, end program */
        call  ZEROS /* Call ZEROS subroutine */
        addi  r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt   r2,r11,STORE2 /* If new max > old max, store new max */
        br    TOP2 /* Load TEST_NUM */
STORE2: mov   r11,r2 /* Store new max to r11 */
        br    TOP2 /* Load TEST_NUM */

XOR_TEST1:
        movia r17,TEST_NUM /* Move TEST_NUM address to r17 */
TOP3:   ldw   r4,(r17) /* Load TEST_NUM */
        beq   r4,r0,XOR_TEST2: /* If TEST_NUM == 0, end program */
        xor   r4,r4,r18 /* First XOR test */
        call  ALTERNATE /* Call ALTERNATE subroutine */
        addi  r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt   r2,r12,STORE3 /* If new max > old max, store new max */
        br    TOP3 /* Load TEST_NUM */
STORE3: mov   r12,r2 /* Store new max to r12 */
        br    TOP3 /* Load TEST_NUM */

XOR_TEST2:
        movia r17,TEST_NUM /* Move TEST_NUM address to r17 */
TOP4:   ldw   r4,(r17) /* Load TEST_NUM */
        beq   r4,r0,CONVERT: /* If TEST_NUM == 0, end program */
        xor   r4,r4,r19 /* Second XOR test */
        call  ALTERNATE /* Call ALTERNATE subroutine */
        addi  r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt   r2,r12,STORE4 /* If new max > old max, store new max */
        br    TOP4 /* Load TEST_NUM */
STORE4: mov   r12,r2 /* Store new max to r12 */
        br    TOP4 /* Load TEST_NUM */

CONVERT:
/* 
    r10 contains highest number of consecutive 1's
    r11 contains highest number of consecutive 0's
    r12 contains highest number of alternating 1's and 0's
*/
        mov   r4,r10 /* Number of 1's input to DIVIDE subroutine */
        call  DIVIDE /* Call DIVIDE subroutine */
        mov   r13,r3 /* Move 10's digit to subroutine input */
        mov   r14,r2 /* Move 1's digit to subroutine input */
        call  DISPLAY_54 /* Call DISPLAY_54 subroutine */
        
        mov   r4,r11 /* Number of 0's input to DIVIDE subroutine */
        call  DIVIDE /* Call DIVIDE subroutine */
        mov   r13,r3 /* Move 10's digit to subroutine input */
        mov   r14,r2 /* Move 1's digit to subroutine input */
        call  DISPLAY_32 /* Call DISPLAY_32 subroutine */

        mov   r4,r12 /* Number of Alt 1's and 0's input to DIVIDE */
        call  DIVIDE /* Call DIVIDE subroutine */
        mov   r13,r3 /* Move 10's digit to subroutine input */
        mov   r14,r2 /* Move 1's digit to subroutine input */
        call  DISPLAY_10 /* Call DISPLAY_10 subroutine */

END:    br    END /* End of Program */

/* r2 holds one's place number, r3 holds tens place number */
DIVIDE:  mov   r2,r4 /* Move contents of r4 to r2 */
		 movi  r5,10 /* Move immediate value of 10 to r5 */
		 movi  r3,0 /* Move immediate value of zero to r3 */
CONT:    blt   r2,r5,DIV_END /* If r2 < r5, branch to DIV_END */
		 sub   r2,r2,r5 /* Subtract 5 from r2, store in r2 */
		 addi  r3,r3,1 /* Add 1 to r3, store in r3 */
		 br    CONT /* Branch program execution to CONT */
DIV_END: ret        /* Exit subroutine */        

DISPLAY_54:
         movia r16,HEX5 /* Load HEX5 address */
         movia r17,HEX4 /* Load HEX4 address */
         mov   r7,r13 /* r13 is input to LOOKUP_TABLE subroutine */
         mov   r23,ra /* Store return address */
         call  LOOKUP_TABLE /* Call LOOKUP_TABLE subroutine */
         mov   ra,r23 /* Load return address */
         stwio r9,0(r16) /* Store Number to HEX5 */
         mov   r7,r14 /* r14 is input to LOOOKUP_TABLE subroutine */
         mov   r23,ra /* Store return address */
         call  LOOKUP_TABLE /* Call LOOKUP_TABLE subroutine */
         mov   ra,r23 /* Load return address */
         stwio r9,0(r17) /* Store number to HEX4 */
         ret        /* Exit subroutine */

DISPLAY_32:
         movia r16,HEX3 /* Load HEX3 address */
         movia r17,HEX2 /* Load HEX2 address */
         mov   r7,r13 /* r13 is input to LOOKUP_TABLE subroutine */
         mov   r23,ra /* Store return address */
         call  LOOKUP_TABLE /* Call LOOKUP_TABLE subroutine */
         mov   ra,r23 /* Load return address */
         stwio r9,0(r16) /* Store number to HEX3 */
         mov   r7,r14 /* r14 is input to LOOKUP_TABLE subroutine */
         mov   r23,ra /* Store return address */
         call  LOOKUP_TABLE /* Call LOOKUP_TABLE subroutine */
         mov   ra,r23 /* Load return address */
         stwio r9,0(r17) /* Store number to HEX2 */
         ret        /* Exit subroutine */

DISPLAY_10:
         movia r16,HEX1 /* Load HEX1 address */
         movia r17,HEX0 /* Load HEX0 address */
         mov   r7,r13 /* r13 is input to LOOKUP_TABLE subroutine */
         mov   r23,ra /* Store return address */
         call  LOOKUP_TABLE /* Call LOOKUP_TABLE subroutine */
         mov   ra,r23 /* Load return address */
         stwio r9,0(r16) /* Store number to HEX1 */
         mov   r7,r14 /* r14 is input to LOOKUP_TABLE subroutine */
         mov   r23,ra /* Store return address */
         call  LOOKUP_TABLE /* Call LOOKUP_TABLE subroutine */
         mov   ra,r23 /* Load return address */
         stwio r9,0(r17) /* Store number to HEX0 */
         ret        /* Exit subroutine */
        
LOOKUP_TABLE:
         mov   r8,r0 /* Initialize r8 to zero */
         beq   r7,r8,LOAD_ZERO /* Is zero? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_ONE /* Is one? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_TWO /* Is two? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_THREE /* Is three? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_FOUR /* Is four? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_FIVE /* Is five? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_SIX /* Is six? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_SEVEN /* Is seven? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_EIGHT /* Is eight? */
         addi  r8,r8,1 /* Increment r8 */
         beq   r7,r8,LOAD_NINE /* Is nine? */
LEAVE:   ret        /* Exit subroutine */

LOAD_ZERO:
         movi  r9,HEX_ZERO
         br    LEAVE
LOAD_ONE:
         movi  r9,HEX_ONE
         br    LEAVE
LOAD_TWO:
         movi  r9,HEX_TWO
         br    LEAVE
LOAD_THREE:
         movi  r9,HEX_THREE
         br    LEAVE
LOAD_FOUR:
         movi  r9,HEX_FOUR
         br    LEAVE
LOAD_FIVE:
         movi  r9,HEX_FIVE
         br    LEAVE
LOAD_SIX:
         movi  r9,HEX_SIX
         br    LEAVE
LOAD_SEVEN:
         movi  r9,HEX_SEVEN
         br    LEAVE
LOAD_EIGHT:
         movi  r9,HEX_EIGHT
         br    LEAVE
LOAD_NINE:
         movi  r9,HEX_NINE
         br    LEAVE

/* Subroutine to find Consecutive 1's in a 32-bit number */
ONES:   
        mov   r2,r0 /* Initialize accumulator to zero */
LOOP1:  beq   r4,r0,EXIT1 /* If TEST_NUM = 0, quit program */
        srli  r6,r4,0x01 /* LSR TEST_NUM by one */
        and   r4,r4,r6 /* AND r9 with shifted num, store in r9 */
        addi  r2,r2,0x01 /* Increment counter */
        br    LOOP1 /* Branch to LOOP */
EXIT1:  ret        /* Exit subroutine */

/* Subroutine to find Consecutive 0's in a 32-bit number */
ZEROS:
        mov   r2,r0 /* Initialize accumulator to zero */
        nor   r4,r4,r0 /* Invert bits by logical NOR with r0 */
LOOP2:  beq   r4,r0,EXIT2 /* If TEST_NUM = 0, quit program */
        srli  r6,r4,0x01 /* LSR TEST_NUM by one */
        and   r4,r4,r6 /* AND r9 with shifted num, store in r9 */
        addi  r2,r2,0x01 /* Increment counter */
        br    LOOP2 /* Branch to LOOP */
EXIT2:  ret        /* Exit subroutine */

/* Subroutine to find Alternating 1's and 0's in a 32-bit number */
ALTERNATE:
        mov   r2,r0 /* Initialize accumulator to zero */
LOOP3:  beq   r4,r0,EXIT3 /* If TEST_NUM = 0, quit program */
        srli  r6,r4,0x01 /* LSR TEST_NUM by one */
        and   r4,r4,r6 /* AND r9 with shifted num, store in r9 */
        addi  r2,r2,0x01 /* Increment counter */
        br    LOOP3 /* Branch to LOOP */
EXIT3:  ret        /* Exit subroutine */

 /* TEST_NUM in memory */
TEST_NUM:  .word 0x3f0101a5
           .word 0x4e0200aa
           .word 0xff737aaa
           .word 0xf000aaaa
           .word 0xffff0000
           .word 0xffff8000
           .word 0xfffff000
           .word 0xfffff800
           .word 0xffffff00
           .word 0xfffffff0
           .word 0xFfffffff
           .word 0x00000000

/* Words to test XOR functionality (a = 1010, 5 = 0101) */
XOR1:      .word 0xaaaaaaaa
XOR2:      .word 0x55555555
		.end        /* End of program */
