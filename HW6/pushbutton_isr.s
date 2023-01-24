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
        movi  r15,0xF /* Value to clear edgecapture */
        stwio r15,KEYS_EDGECAPTURE(r10) /* Clear the interrupt */
CHECK_KEY1:
        andi  r13,r11,0b0001 /* Check KEY1 */
        beq   r13,r0,CHECK_KEY2 /* If not KEY1, check KEY2 */
        beq   r18,r0,REMOVE_1 /* If counter not zero, blank display */
SHOW_1:
        movi  r18,0 /* Set KEY1 counter to one */
        movia r12,BLANK7SEG /* Value to clear 7-SEG display */
        slli  r12,r12,8 /* Logical shift left 8 bits */
        addi  r12,r12,HEX1 /* Move value to show 1 on 7-SEG */
        movia r13,HEX3210 /* Load address of first four 7-SEGS */
        stwio r12,(r13)  /* Store value to 7-SEGS */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
REMOVE_1:
        movi  r18,1 /* Set KEY1 counter to zero */
        movia r12,BLANK7SEG /* Move value to show nothing on 7-SEG */
        movia r13,HEX3210 /* Load address of first four 7-SEGS */
        stwio r12,(r13)  /* Store value to 7-SEGS */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
LEAVE_1:
        movi  r15,0b0010 /* Clear KEY1 edgecapture register */
        stwio r15,KEYS_EDGECAPTURE(r10) /* Clear the edgecapture register */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
CHECK_KEY2:
        andi  r13,r11,0b0010 /* Check KEY2 */
        beq   r13,r0,CHECK_KEY3  /* If not KEY2, check KEY3 */
        beq   r19,r0,REMOVE_2 /* If counter not zero, blank display */
SHOW_2:
        movi  r19,0 /* Set KEY2 counter to one */
        movia r12,BLANK7SEG /* Value to clear 7-SEG Display */
        slli  r12,r12,8 /* Logical shift left 8 bits */
        addi  r12,r12,HEX2 /* Add 7-SEG value for 2 */
        slli  r12,r12,8 /* Logical shift left 8 bits */
        addi  r12,r12,HEXOFF /* Add 7-SEG value for blank */
        movia r13,HEX3210 /* Load address of first four 7-SEGS */
        stwio r12,(r13)  /* Store value to 7-SEGS */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
REMOVE_2:
        movi  r19,1 /* Set KEY2 counter to zero */
        movia r12,BLANK7SEG /* Move value to show nothing on 7-SEG */
        movia r13,HEX3210 /* Load address of first four 7-SEGS */
        stwio r12,(r13)  /* Store value to 7-SEGS */
        br    END_PUSHBUTTON_ISR/* Branch to END_PUSHBUTTON_ISR */
LEAVE_2:
        movi  r15,0b0100 /* Clear KEY2 edgecapture register */
        stwio r15,KEYS_EDGECAPTURE(r10) /* clear the edgecapture register */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
CHECK_KEY3:
        andi  r13,r11,0b0100 /* check KEY2 */
        beq   r13,r0,END_PUSHBUTTON_ISR  /* If not KEY3, exit */
        beq   r20,r0,REMOVE_3 /* If counter not zero, blank display */
SHOW_3:
        movi  r20,0 /* Set KEY3 counter to one */
        movia r12,BLANK7SEG /* Add 7-SEG value for blank */
        slli  r12,r12,8 /* Logical shift left 8 bits */
        addi  r12,r12,HEX3 /* Add 7-SEG value for 3 */
        slli  r12,r12,8 /* Logical shift left 8 bits */
        addi  r12,r12,HEXOFF /* Add 7-SEG value for blank */
        slli  r12,r12,8 /* Logical shift left 8 bits */
        addi  r12,r12,HEXOFF /* Add 7-SEG value for blank */
        movia r13,HEX3210 /* Load address of first four 7-SEGS */
        stwio r12,(r13)  /* Store value to 7-SEGS */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
REMOVE_3:
        movi  r20,1 /* Set KEY3 counter to zero */
        movia r12,BLANK7SEG /* Move value to show nothing on 7-SEG */
        movia r13,HEX3210 /* Load address of first four 7-SEGS */
        stwio r12,(r13)  /* Store value to 7-SEGS */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
LEAVE_3:
        movi  r15,0b1000 /* Clear KEY3 edgecapture register */
        stwio r15,KEYS_EDGECAPTURE(r10) /* clear the edgecapture register */
        br    END_PUSHBUTTON_ISR /* Branch to END_PUSHBUTTON_ISR */
END_PUSHBUTTON_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        ldwio r13,16(sp) /* Restore r13 from stack */
        addi  sp,sp,20 /* Add 5 bytes to stack pointer address */
        ret /* Return from PUSHBUTTON_ISR */
.end


