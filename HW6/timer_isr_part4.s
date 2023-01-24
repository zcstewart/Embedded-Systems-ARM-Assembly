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
        movia r10,TIMER /* Move timer address to r10 */
        movi  r13,0b0001 /* Value to clear TO bit */
        stwio r13,TIMER_STATUS(r10) /* Clear TO bit */
/*
   INCREMENT_SUB subroutine
   The purpose of this subroutine is to increment milliseconds
   and seconds if necessary.
*/
INCREMENT_SUB:
        addi  r17,r17,1 /* increment milliseconds counter */
        bne   r17,r19,CONVERT_NUM /* compare milliseconds to 100 */
        movi  r17,0 /* If 100, reset milliseconds */
        addi  r16,r16,1 /* If 100, increment seconds */
        bne   r16,r18,CONVERT_NUM /* compare seconds to 60 */
        movi  r17,0 /* If 60, reset milliseconds */
        movi  r16,0 /* If 60, reset seconds */
CONVERT_NUM:
        /* Convert Milliseconds */
        mov   r4,r17 /* move milliseconds counter to subroutine input */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r11,r2 /* move ones place to r11 */
        mov   r10,r3 /* move tens place to r10 */
        mov   r4,r11 /* move ones place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r11,r2 /* move output back to r6 */
        mov   r4,r10 /* move tens place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r10,r2 /* move output back to r5 */
        
        /* Convert Seconds */
        mov   r4,r16 /* move seconds counter to subroutine input */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r9,r2 /* move ones place to r11 */
        mov   r8,r3 /* move tens place to r10 */
        mov   r4,r9 /* move ones place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r9,r2 /* move output back to r6 */
        mov   r4,r8 /* move tens place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r8,r2 /* move output back to r5 */

        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        br    END_TIMER_ISR

/* 
   DIVIDE subroutine
   r2 holds one's place number, r3 holds tens place number 
*/
DIVIDE:  mov   r2,r4 /* Move contents of r4 to r2 */
		 movi  r5,10 /* Move immediate value of 10 to r5 */
		 movi  r3,0 /* Move immediate value of zero to r3 */
CONT:    blt   r2,r5,DIV_END /* If r2 < r5, branch to DIV_END */
		 sub   r2,r2,r5 /* Subtract 5 from r2, store in r2 */
		 addi  r3,r3,1 /* Add 1 to r3, store in r3 */
		 br    CONT /* Branch program execution to CONT */
DIV_END: ret /* exit subroutine */ 

/*
   SEG7_CODE subroutine
   Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
   Parameters: r4 = the decimal value of the digit to be displayed
   Returns: r2 = bit pattern to be written to the HEX display
*/
SEG7_CODE: 
         movia  r3, BIT_CODES /* load bitcodes to r15 */
         add    r3, r3, r4 /* add number as byte offset */
         ldbuio r2, (r3) /* load 7-seg value */
         ret /* exit subroutine */

/*
   DISPLAY_3210 subroutine
   R17 holds address of HEX3210
   Input: r8,r9,r10,r11
          Tens_s,Ones_s,Tens_ms,Ones_ms
   Output: store r2 to 7-SEG
*/
DISPLAY_3210:
        movia  r3,HEX3210 /* load HEX3210 address */
        mov    r2,r8 /* move 10's seconds */
        slli   r2,r2,8 /* logical shift left 1 byte */
        or     r2,r2,r9 /* concatenate 1's seconds */
        slli   r2,r2,8 /* logical shift left 1 byte */
        or     r2,r2,r10 /* concatenate 10's milliseconds */
        slli   r2,r2,8 /* logical shift left 1 byte */
        or     r2,r2,r11 /* concatenate 1's milliseconds */
        stwio  r2,0(r3) /* store value to HEX3210 */
        ret /* exit subroutine */
END_TIMER_ISR:
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        addi  sp,sp,16 /* Add 5 bytes to stack pointer address */
        ret /* Return from TIMER_ISR */

        .end
