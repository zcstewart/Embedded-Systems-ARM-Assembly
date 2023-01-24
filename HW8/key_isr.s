/*
	Zachary Stewart
    KEY_ISR
*/

/********************************************************************************
* Pushbutton - Interrupt Service Routine

  KEY1: "Note Down"

  KEY2: "Note Up"

  KEY3: "Start/Stop"
********************************************************************************/
        .include "address_map.s"

        .global KEY_ISR

KEY_ISR:
        subi  sp,sp,20 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
        stwio r13,16(sp) /* Store r13 to stack pointer */

        movia r10,KEYS /* Base address of pushbutton KEY parallel port */
        ldwio r11,KEYS_EDGECAPTURE(r10) /* Read edge capture register */
        movi  r12,0xF /* Value to clear edgecapture */
        stwio r12,KEYS_EDGECAPTURE(r10) /* Clear the interrupt */
CHECK_KEY1:
        andi  r13,r11,0b0001 /* Check KEY1 */
        beq   r13,r0,CHECK_KEY2 /* If not KEY1, check KEY2 */
        br    KEY1_ROUTINE /* If counter not zero, blank display */
CHECK_KEY2:
        andi  r13,r11,0b0010 /* Check KEY2 */
        beq   r13,r0,CHECK_KEY3 /* If not KEY2, check KEY3 */
        br    KEY2_ROUTINE /* If counter not zero, blank display */
CHECK_KEY3:
        andi  r13,r11,0b0100 /* Check KEY3 */
        beq   r13,r0,END_KEY_ISR /* If not KEY3, exit */
        br    KEY3_ROUTINE /* If counter not zero, blank display */

END_KEY_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        ldwio r13,16(sp) /* Restore r13 from stack */
        addi  sp,sp,20 /* Add 5 bytes to stack pointer address */
        ret /* Return from PUSHBUTTON_ISR */

KEY1_ROUTINE:
        beq  r9,r0,END_KEY_ISR
        subi r18,r18,0x4
        subi r9,r9,0x4
/* Stop Timer */
        movia r10,TIMER
        movi  r11,0b1000
        stwio r11,TIMER_CONTROL(r10)
/* Load New Period */
        ldwio r11,(r18)
        movia r10,TIMER
        sthio r11,TIMER_PERIODL(r10)
        srli  r11,r11,16
        sthio r11,TIMER_PERIODH(r10)
/* Start Timer */
        movi  r11,0b0111
        stwio r11,TIMER_CONTROL(r10)
        br    END_KEY_ISR

KEY2_ROUTINE:
        beq  r9,r7,END_KEY_ISR
        addi r18,r18,0x4
        addi r9,r9,0x4
/* Stop Timer */
        movia r10,TIMER
        movi  r11,0b1000
        stwio r11,TIMER_CONTROL(r10)
/* Load New Period */
        ldwio r11,(r18)
        sthio r11,TIMER_PERIODL(r10)
        srli  r11,r11,16
        sthio r11,TIMER_PERIODH(r10)
/* Start Timer */
        movi  r11,0b0111
        stwio r11,TIMER_CONTROL(r10)
        br    END_KEY_ISR

KEY3_ROUTINE:
        beq   r6,r0,AUDIO_ON
AUDIO_OFF:
        mov   r6,r0
/* Stop Timer */
        movia r10,TIMER
        movi  r11,0b1000
        stwio r11,TIMER_CONTROL(r10)
/* Clear Timer Interrupt */
        movi  r11,0b0001
        stwio r11,TIMER_STATUS(r10)
/* Turn Off GPIO */
        movia r10,GPIO
        movi  r11,0b0
        stwio r11,GPIO_DATA(r10)
        br    END_KEY_ISR
AUDIO_ON:
        movi  r6,0b1
/* Clear Timer Interrupt */
        movia r10,TIMER
        movi  r11,0b0001
        stwio r11,TIMER_STATUS(r10)
/* Load Timer Period */
        ldwio r11,(r18)
        sthio r11,TIMER_PERIODL(r10)
        srli  r11,r11,16
        sthio r11,TIMER_PERIODH(r10)
/* Start Timer */
        movi  r11,0b0111
        stwio r11,TIMER_CONTROL(r10)
        br    END_KEY_ISR

.end
