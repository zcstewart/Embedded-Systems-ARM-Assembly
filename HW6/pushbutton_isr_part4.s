/********************************************************************************
* Timer - Interrupt Service Routine
*
* This routine checks which KEY has been pressed. 
* 
* 
********************************************************************************/
        .include "address_map.s"

        .global PUSHBUTTON_ISR

PUSHBUTTON_ISR:
        subi  sp,sp,16 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
CLEAR_KEY_INTERRUPT:
        movi  r12,0b1111 /* Value to clear Edgecapture */
        stwio r12,KEYS_EDGECAPTURE(r15) /* clear Edgecapture register */
        bne   r13,r0,TIMER_OFF /* Check timer on/off value */
TIMER_ON:
        movi  r13,0x01 /* Value indicating timer is on */
        movi  r12,0b0111 /* Value to start timer */
        stwio r12,TIMER_CONTROL(r14) /* START = 1, CONT = 1, ITO = 1 */
        br    END_PUSHBUTTON_ISR /* Exit TIMER_ISR */
TIMER_OFF:
        movi  r13,0x00 /* Value indicating timer is off */
        movi  r12,0b1000 /* Value to stop timer */
        stwio r12,TIMER_CONTROL(r14) /* STOP = 1 */
END_PUSHBUTTON_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        addi  sp,sp,16 /* Add 5 bytes to stack pointer address */
        ret /* Return from TIMER_ISR */

        .end
