/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 4 Part 2
*/

		.text


        .global _start /* Beginning of program */

_start:

        ldw     r9,TEST_NUM(r0) /* Load TEST_NUM */
        mov     r10,r0 /* Initialize accumulator to zero */
LOOP:   beq     r9,r0,END /* If TEST_NUM = 0, quit program */
        srli    r11,r9,0x01 /* LSR TEST_NUM by one */
        and     r9,r9,r11 /* AND r9 with shifted num, store in r9 */
        addi    r10,r10,0x01 /* Increment counter */
        br      LOOP /* Branch to LOOP */

END:    br      END /* End of Program */

 /* TEST_NUM in memory */
TEST_NUM:       .word 0x3fabedef

		.end        /* End of program */
