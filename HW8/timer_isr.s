/*
	Zachary Stewart
    TIMER_ISR
*/

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
        subi  sp,sp,16 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
CLEAR_TIMER_INTERRUPT:
        movia r10,TIMER
        movi  r11,0b0001
        stwio r11,TIMER_STATUS(r10)
INVERT_SIGNAL:
        beq   r8,r0,GPIO_HIGH
GPIO_LOW:
        movi  r8,0b0
        br    STORE_GPIO
GPIO_HIGH:
        movi  r8,0b1
STORE_GPIO:
        movia r10,GPIO
        stwio r8,GPIO_DATA(r10)
END_TIMER_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        addi  sp,sp,16 /* Add 5 bytes to stack pointer address */
        
        ret /* Return from TIMER_ISR */

        .end
