/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 3 Part 1
*/
		.text
		.global _start /* Beginning of program */

_start:
		 movia r4,N /* Move immediate address of N to r4 */
		 addi  r8,r4,4 /* Increment address by 4 bytes, store in r8 */
		 ldw   r4,(r4) /* Load word from address contained in r4 to r4 */
		 call  DIVIDE /* Call DIVIDE subroutine */
		 stb   r3,1(r8) /* Store contents of r3 to address in r8 + 1 byte */
		 stb   r2,(r8) /* Store contents of r2 to address in r8 */
END:     br    END /* Branch program execution to label "END" */

DIVIDE:  mov   r2,r4 /* Move contents of r4 to r2 */
		 movi  r5,10 /* Move immediate value of 10 to r5 */
		 movi  r3,0 /* Move immediate value of zero to r3 */
CONT:    blt   r2,r5,DIV_END /* If r2 < r5, branch to DIV_END */
		 sub   r2,r2,r5 /* Subtract 5 from r2, store in r2 */
		 addi  r3,r3,1 /* Add 1 to r3, store in r3 */
		 br    CONT /* Branch program execution to CONT */
DIV_END: ret        /* Exit subroutine */

N:      .word 76    /* Decimal word to be converted */
Digits: .space 4    /* Zero Space created to store result */

		.end        /* End of program */
