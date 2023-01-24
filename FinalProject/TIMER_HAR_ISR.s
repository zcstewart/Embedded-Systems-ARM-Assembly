/********************************************************************************
* Timer_HAR - Interrupt Service Routine
*
* This routine toggles the GPIO_HAR. 
* 
* 
********************************************************************************/
        .include "address_map.s"

        .global TIMER_HAR_ISR

TIMER_HAR_ISR:
        subi  sp,sp,16 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
CLEAR_TIMER_INTERRUPT:
        movia r10,TIMER_HAR
        movi  r11,0b0001
        stwio r11,TIMER_STATUS(r10)
INVERT_SIGNAL:
        beq   r14,r0,HAR_HIGH
        beq   r14,r5,HAR_LOW
        beq   r14,r8,HAR_OFF
HAR_LOW:
        movi  r14,0
        br    HAR_GPIO
HAR_HIGH:
        movi  r14,1
        br    HAR_GPIO
HAR_OFF:
        movia r12, GPIO_HAR
        stwio r0,(r12)
        br    START_TIMER
HAR_GPIO:
        movia r12,GPIO_HAR
        stwio r14,(r12)
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
