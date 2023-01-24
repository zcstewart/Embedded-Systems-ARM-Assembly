/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 3 Part 2
*/
		 .text
		 .global _start /* Beginning of program */
_start:
		 movia r4,N /* Move address of N to r4 */
		 addi  r8,r4,7 /* Add 7 to address of r4, store in r8*/
		 ldw   r4,(r4) /* Load value of N to r4 */
         movia r6,Divisor /* Load divisor address to r6 */
         ldw   r5,(r6) /* Load divisor to r5 */
         movi  r10,3 /* Move counter variable 3 to r10 */
SUBCALL: call  DIVIDE /* Call DIVIDE subroutine */
         addi  r6,r6,4 /* Increment r6 by four bytes */
         ldw   r5,(r6) /* Load next divisor */
         subi  r10,r10,1  /* Decrement counter */
         bgt   r10,r0,SUBCALL /* If counter =/= 0, call subroutine */
STORE:   stbio r4,(r8) /* Store remainder to first byte of digits */
END:     br    END /* Branch program execution to label "END" */
DIVIDE:  mov   r2,r4 /* Move r4 to r2 for subroutine input */
		 movi  r3,0 /* Set r3 to zero */
CONT:    blt   r2,r5,DIV_END /* If r2 < r5, branch to DIV_END */
		 sub   r2,r2,r5 /* Subtract divisor from r2, store in r2 */
		 addi  r3,r3,1 /* Increment remainder stored in r3 */
		 br    CONT /* Branch program execution to CONT */
DIV_END: stbio r3,(r8) /* store remainder in Digits */
         subi  r8,r8,1 /* Increment Digits by 1 byte */
         mov   r4,r2 /* Update "new" N value */
         ret        /* Exit subroutine */

N:       .word 9876    /* Decimal word to be converted */
Digits:  .space 4    /* Zero Space created to store result */
Divisor: .word 1000,100,10 /* Array of divisors used */
		 .end        /* End of program */