/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 4 Part 4
*/
		.text
		.equ HEX0,     0x202070 /* Address of HEX0 */
        .equ HEX1,     0x202060 /* Address of HEX1 */
        .equ HEX2,     0x202050 /* Address of HEX2 */
        .equ HEX3,     0x202040 /* Address of HEX3 */
        .equ HEX4,     0x202090 /* Address of HEX4 */
        .equ HEX5,     0x202080 /* Address of HEX5 */

        .global _start /* Beginning of program */

_start:
        /* 
           7-Segment Displays are common anode, must write 1 to 
           turn off each segment
        */
HEXOFF:
        movi    r15,0x7F /* Value to turn off 7-segment display */
        movia   r16,HEX0 /* Load address of HEX0 */
        stwio   r15,0(r16) /* Turn off HEX0 */
        movia   r16,HEX1 /* Load address of HEX1 */
        stwio   r15,0(r16) /* Turn off HEX1 */
        movia   r16,HEX2 /* Load address of HEX2 */
        stwio   r15,0(r16) /* Turn off HEX2 */
        movia   r16,HEX3 /* Load address of HEX3 */
        stwio   r15,0(r16) /* Turn off HEX3 */
        movia   r16,HEX4 /* Load address of HEX4 */
        stwio   r15,0(r16) /* Turn off HEX4 */
        movia   r16,HEX5 /* Load address of HEX5 */
        stwio   r15,0(r16)  /* Turn off HEX5 */

        mov     r10,r0 /* Initialize r10 to zero (consecutive 1's) */
        mov     r11,r0 /* Initialize r11 to zero (consective 0's) */
        mov     r12,r0 /* Initialize r12 to zero (alternating 10) */
       
        movia   r17,TEST_NUM /* Move TEST_NUM address to r17 */
        movia   r18,XOR1 /* Move XOR_TEST1 address to r18 */
        movia   r19,XOR2 /* Move XOR_TEST2 address to r19 */
        ldw     r18,(r18) /* Load value for first XOR test */
        ldw     r19,(r19) /* Load value for second XOR test */
TOP1:   ldw     r4,0(r17) /* Load TEST_NUM */
        beq     r4,r0,NEXT_ZEROS /* If TEST_NUM == 0, end program */
        call    ONES /* Call ONES subroutine */
        addi    r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt     r2,r10,STORE1 /* If new max > old max, store new max */
        br      TOP1 /* Load TEST_NUM */
STORE1: mov     r10,r2 /* Store new max to r10 */
        br      TOP1 /* Load TEST_NUM */

NEXT_ZEROS:

        movia   r17,TEST_NUM /* Move TEST_NUM address to r17 */
TOP2:   ldw     r4,(r17) /* Load TEST_NUM */
        beq     r4,r0,XOR_TEST1 /* If TEST_NUM == 0, end program */
        call    ZEROS /* Call ZEROS subroutine */
        addi    r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt     r2,r11,STORE2 /* If new max > old max, store new max */
        br      TOP2 /* Load TEST_NUM */
STORE2: mov     r11,r2 /* Store new max to r11 */
        br      TOP2 /* Load TEST_NUM */

XOR_TEST1:

        movia   r17,TEST_NUM /* Move TEST_NUM address to r17 */
TOP3:   ldw     r4,(r17) /* Load TEST_NUM */
        beq     r4,r0,XOR_TEST2: /* If TEST_NUM == 0, end program */
        xor     r4,r4,r18 /* First XOR test */
        call    ALTERNATE /* Call ALTERNATE subroutine */
        addi    r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt     r2,r12,STORE3 /* If new max > old max, store new max */
        br      TOP3 /* Load TEST_NUM */
STORE3: mov     r12,r2 /* Store new max to r12 */
        br      TOP3 /* Load TEST_NUM */


XOR_TEST2:

        movia   r17,TEST_NUM /* Move TEST_NUM address to r17 */
TOP4:   ldw     r4,(r17) /* Load TEST_NUM */
        beq     r4,r0,END: /* If TEST_NUM == 0, end program */
        xor     r4,r4,r19 /* Second XOR test */
        call    ALTERNATE /* Call ALTERNATE subroutine */
        addi    r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt     r2,r12,STORE4 /* If new max > old max, store new max */
        br      TOP4 /* Load TEST_NUM */
STORE4: mov     r12,r2 /* Store new max to r12 */
        br      TOP4 /* Load TEST_NUM */

END:    br      END /* End of Program */

/* Subroutine to find Consecutive 1's in a 32-bit number */
ONES:   
        mov     r2,r0 /* Initialize accumulator to zero */
LOOP1:  beq     r4,r0,EXIT1 /* If TEST_NUM = 0, quit program */
        srli    r6,r4,0x01 /* LSR TEST_NUM by one */
        and     r4,r4,r6 /* AND r9 with shifted num, store in r9 */
        addi    r2,r2,0x01 /* Increment counter */
        br      LOOP1 /* Branch to LOOP */
EXIT1:  ret

/* Subroutine to find Consecutive 0's in a 32-bit number */
ZEROS:
        mov     r2,r0 /* Initialize accumulator to zero */
        nor     r4,r4,r0 /* Invert bits by logical NOR with r0 */
LOOP2:  beq     r4,r0,EXIT2 /* If TEST_NUM = 0, quit program */
        srli    r6,r4,0x01 /* LSR TEST_NUM by one */
        and     r4,r4,r6 /* AND r9 with shifted num, store in r9 */
        addi    r2,r2,0x01 /* Increment counter */
        br      LOOP2 /* Branch to LOOP */
EXIT2:  ret

/* Subroutine to find Alternating 1's and 0's in a 32-bit number */
ALTERNATE:
        mov     r2,r0 /* Initialize accumulator to zero */
LOOP3:  beq     r4,r0,EXIT3 /* If TEST_NUM = 0, quit program */
        srli    r6,r4,0x01 /* LSR TEST_NUM by one */
        and     r4,r4,r6 /* AND r9 with shifted num, store in r9 */
        addi    r2,r2,0x01 /* Increment counter */
        br      LOOP3 /* Branch to LOOP */
EXIT3:  ret

 /* TEST_NUM in memory */
TEST_NUM:       .word 0xff00aa11
                .word 0xffffaaaa
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

XOR1:      .word 0xaaaaaaaa
XOR2:      .word 0x55555555
      
		.end        /* End of program */