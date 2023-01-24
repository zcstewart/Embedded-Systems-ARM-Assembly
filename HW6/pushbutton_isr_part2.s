/********************************************************************************
* Pushbutton - Interrupt Service Routine
********************************************************************************/
        .include "address_map.s"

        .global PUSHBUTTON_ISR

PUSHBUTTON_ISR:
        subi  sp,sp,20 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
        stwio r13,16(sp) /* Store r13 to stack pointer */
        movia r10,KEYS /* Base address of pushbutton KEY parallel port */
        ldwio r11,KEYS_EDGECAPTURE(r10) /* read edge capture register */
        movi  r15,0b1111 /* Value to clear edgecapture */
        stwio r15,KEYS_EDGECAPTURE(r10) /* Clear the interrupt */
CHECK_KEYS:
        andi  r13,r11,0b1111 /* Check for KEY press */
        beq   r13,r0,END_PUSHBUTTON_ISR /* If no KEYS pressed, exit */
        movia r11,RUN /* Load address of RUN variable */
        ldwio r18,(r11) /* Load RUN variable */
        beq   r18,r0,TOGGLE_RUN_HIGH /* If counter not zero, blank display */
TOGGLE_RUN_LOW:
        movi  r18,0x0 /* Move 0 to r18 */
        stwio r18,(r11) /* Change RUN to 0 */
        br END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
TOGGLE_RUN_HIGH:
        movi  r18,0x1 /* Move 1 to r18 */
        stwio r18,(r11) /* Change RUN to 1 */
END_PUSHBUTTON_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        ldwio r13,16(sp) /* Restore r13 from stack */
        addi  sp,sp,20 /* Add 5 bytes to stack pointer address */
        ret /* Return from PUSHBUTTON_ISR */
.end


