/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 4 Part 3
*/
		.text


        .global _start /* Beginning of program */

_start:
=
        movia   r17,TEST_NUM /* Move TEST_NUM address to r17 */
        mov     r10,r0 /* Initialize r10 to zero (consecutive 1's) */
TOP:    ldw     r4,(r17) /* Load TEST_NUM */
        beq     r4,r0,END /* If TEST_NUM == 0, end program */
        call    ONES /* Call ONES subroutine */
        addi    r17,r17,4 /* Increment TEST_NUM address 4 bytes */
        bgt     r2,r10,STORE /* If new max > old max, store new max */
        br      TOP /* Load TEST_NUM */
STORE:  mov     r10,r2 /* Store new max to r10 */
        br      TOP /* Load TEST_NUM */

END:    br      END /* End of Program */

ONES:   mov     r2,r0 /* Initialize accumulator to zero */
LOOP:   beq     r4,r0,EXIT /* If TEST_NUM = 0, quit program */
        srli    r6,r4,0x01 /* LSR TEST_NUM by one */
        and     r4,r4,r6 /* AND r9 with shifted num, store in r9 */
        addi    r2,r2,0x01 /* Increment counter */
        br      LOOP /* Branch to LOOP */
EXIT:   ret

 /* TEST_NUM in memory */
TEST_NUM:       .word 0x3f0101a5
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

		.end        /* End of program */
