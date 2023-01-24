/********************************************************************************
* Timer - Interrupt Service Routine
*
* This routine checks which KEY has been pressed. 
* 
* 
********************************************************************************/
        .include "address_map.s"

        .global TIMER_ISR

TIMER_ISR:
        subi  sp,sp,28 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
        stwio r13,16(sp) /* Store r13 to stack pointer */
        stwio r14,20(sp) /* store r14 to stack pointer */
        stwio r15,24(sp) /* store r15 to stack pointer */
CLEAR_TIMER_INTERRUPT:
        movia r10,TIMER /* Move timer address to r10 */
        movi  r13,0b0001 /* TO bit */
        stwio r13,TIMER_STATUS(r10) /* Clear TO bit */
LOAD_VALUES:
        movia r11,COUNT /* Move COUNT address to r11 */
        movia r12,RUN /* Move RUN address to r12 */
        ldwio r13,(r11) /* Load value of COUNT to r13 */
        ldwio r14,(r12) /* Load value of RUN to r14 */
INCREMENT_COUNT:
        add   r13,r13,r14 /* Add RUN to COUNT, store to COUNT */
        movia r15,LEDR /* Move address of LEDR  */
        stwio r13,(r15) /* Store COUNT to LEDR */
        stwio r13,(r11) /* Update COUNT */
END_TIMER_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        ldwio r13,16(sp) /* Restore r13 from stack */
        ldwio r14,20(sp) /* Restore r14 from stack */
        ldwio r15,24(sp) /* Restore r15 from stack */
        addi  sp,sp,28 /* Add 5 bytes to stack pointer address */
        ret /* Return from TIMER_ISR */

        .end
