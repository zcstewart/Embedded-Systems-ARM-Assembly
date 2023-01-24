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

/* Double Rate by halving (Logical shift right) Timeout Period */
CHECK_KEY1:
        andi  r13,r11,0b001 /* Check KEY1 */
        beq   r13,r0,CHECK_KEY2 /* If no KEYS pressed, exit */
KEY1_ROUTINE:
        movia  r11,TIMER /* Load address of timer */
        movi   r12,0b1000 /* Value to stop timer */
        stwio  r12,TIMER_CONTROL(r11) /* Stop Timer */
        ldhuio r12,TIMER_PERIODH(r11) /* Load PERIODH to r12 */
        ldhuio r13,TIMER_PERIODL(r11) /* Load PERIODL to r13 */
        slli   r12,r12,16 /* Shift r12 left 16 bits */
        add    r12,r12,r13 /* Add r12 and r13 */
        srli   r12,r12,1 /* Logical shift right 1 bit */
        sthio  r12,TIMER_PERIODL(r11) /* Store halfword to PERIODL */
        srli   r12,r12,16 /* Shift right 16 bits */
        sthio  r12,TIMER_PERIODH(r11) /* Store halfword to PERIODH */
        movi   r12,0b0111 /* Start = 1, CONT = 1, ITO = 1 */
        stwio  r12,TIMER_CONTROL(r11) /* Start continuous int timer */
        br     END_PUSHBUTTON_ISR /* Exit PUSHBUTTON_ISR */

/* Halve Rate by doubling (Logical shift left) Timeout Period */
CHECK_KEY2:
        andi  r13,r11,0b010 /* Check KEY2 */
        beq   r13,r0,CHECK_KEY3 /* If no KEYS pressed, exit */
KEY2_ROUTINE:
        movia  r11,TIMER /* Load TIMER address */
        movi   r12,0b1000 /* value to stop timer */
        stwio  r12,TIMER_CONTROL(r11) /* STOP = 1 */
        ldhuio r12,TIMER_PERIODH(r11) /* Load PERIODH */
        ldhuio r13,TIMER_PERIODL(r11) /* Load PERIODL */
        slli   r12,r12,16 /* Logical shift left 16 bits */
        add    r12,r12,r13 /* Add r13 to r12 */
        slli   r12,r12,1 /* Logical shift left 1 bit */
        sthio  r12,TIMER_PERIODL(r11) /* Store halfword to TIMER_PERIODL */
        srli   r12,r12,16 /* Logical shift right 16 bits */
        sthio  r12,TIMER_PERIODH(r11) /* Store halfword to TIMER_PERIODH */
        movi   r12,0b0111 /* START = 1, CONT = 1, ITO = 1 */
        stwio  r12,TIMER_CONTROL(r11) /* Start timer */
        br     END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
CHECK_KEY3:
        andi  r13,r11,0b100 /* Check KEY3 */
        beq   r13,r0,END_PUSHBUTTON_ISR /* If no KEYS pressed, exit */
KEY3_ROUTINE:
        movia r11,RUN /* Load address of RUN variable */
        ldwio r18,(r11) /* Load RUN variable */
        beq   r18,r0,TOGGLE_RUN_HIGH /* If counter not zero, blank display */
TOGGLE_RUN_LOW:
        movi  r18,0x0 /* Move 0 to r18 */
        stwio r18,(r11) /* Change RUN to 0 */
        br    END_PUSHBUTTON_ISR
TOGGLE_RUN_HIGH:
        movi  r18,0x1 /* Move 1 to r18 */
        stwio r18,(r11) /* Change RUN to 1 */
        br   END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */

END_PUSHBUTTON_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        ldwio r13,16(sp) /* Restore r13 from stack */
        addi  sp,sp,20 /* Add 5 bytes to stack pointer address */
        ret /* Return from PUSHBUTTON_ISR */
.end


