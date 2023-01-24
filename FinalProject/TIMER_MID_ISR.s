/********************************************************************************
* Timer - Interrupt Service Routine
*
* This routine checks which KEY has been pressed. 
* 
* 
********************************************************************************/
        .include "address_map.s"

        .global TIMER_MID_ISR

TIMER_MID_ISR:
        subi  sp,sp,16 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
CLEAR_TIMER_INTERRUPT:
        movia r10,TIMER_MID
        movi  r11,0b0001
        stwio r11,TIMER_STATUS(r10)
INVERT_SIGNAL:
        beq   r15,r0,MID_HIGH
        beq   r15,r8,MID_OFF
MID_LOW:
        movi  r15,0
        br    MID_GPIO
MID_HIGH:
        movi  r15,1
        br    MID_GPIO
MID_OFF:
        movia r12, GPIO_RHY
        stwio r0,(r12)
        br    START_TIMER
MID_GPIO:
        movia r12,GPIO_MID
        stwio r15,(r12)
START_TIMER:
        movi  r11,0b0111
        stwio r11,TIMER_CONTROL(r10)
END_TIMER_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        addi  sp,sp,16 /* Add 5 bytes to stack pointer address */
        
        ret /* Return from TIMER_ISR */

        .end
