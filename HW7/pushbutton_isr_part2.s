/********************************************************************************
* Pushbutton - Interrupt Service Routine

  KEY1: "CLEAR"

  KEY2: "STOP"

  KEY3: "START"
********************************************************************************/
        .include "address_map.s"

        .global PUSHBUTTON_ISR

PUSHBUTTON_ISR:
        subi  sp,sp,24 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
        stwio r13,16(sp) /* Store r13 to stack pointer */
        stwio r14,20(sp) /* Store r14 to stack pointer */
        movia r10,KEYS /* Base address of pushbutton KEY parallel port */
        ldwio r11,KEYS_EDGECAPTURE(r10) /* Read edge capture register */
        movi  r12,0xF /* Value to clear edgecapture */
        stwio r12,KEYS_EDGECAPTURE(r10) /* Clear the interrupt */
CHECK_KEY1:
        andi  r13,r11,0b0001 /* Check KEY1 */
        beq   r13,r0,END_PUSHBUTTON_ISR /* If not KEY1, check KEY2 */
        br    KEY1_ROUTINE /* If counter not zero, blank display */

END_PUSHBUTTON_ISR:
        movia r12,KEYS
        movi  r10,0b111
        stwio r10,KEYS_EDGECAPTURE(r11)
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        ldwio r13,16(sp) /* Restore r13 from stack */
        ldwio r14,20(sp) /* Restore r14 from stack */
        addi  sp,sp,24 /* Add 5 bytes to stack pointer address */
        ret /* Return from PUSHBUTTON_ISR */

/* CLEAR KEY = KEY 1 */
KEY1_ROUTINE:
        mov   r16,r0 /* initialize seconds counter to zero */
        mov   r17,r0 /* initialize milliseconds counter to zero */
        movia r12,KEYS
        movi  r10,0b111
        stwio r10,KEYS_EDGECAPTURE(r12)
BEGIN_KEY1:
        call  DISPLAY_HELLO /* Call DISPLAY_HELLO subroutine */
        call  CLEAR_LEDS /* Call CLEAR_LEDS subroutine */
RAND_TIMER_SEED:
        movia  r11,TIMER /* Load TIMER address */
        movi   r10,0b1000 /* Stop bit high */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit high */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */
        movia  r14,TIMER_2sDELAY /* Load 2 second delay value */
        ldwio  r10,(r14)
        sthio  r10,TIMER_PERIODL(r11) /* Store low two bytes to PERIODL */
        srli   r10,r10,16 /* Loagical shift left 2 bytes */
        sthio  r10,TIMER_PERIODH(r11) /* Store high two bytes to PERIODH */
        movi   r10,0b0110 /* START = 1, CONT = 1, ITO = 0 */
        stwio  r10,TIMER_CONTROL(r11) /* Store value to control register */
        movia  r12,KEYS /* Load address of KEYS */
        movi   r13,0b0100 /* Value for KEY3 */

POLL_KEY3:
        ldwio  r10,KEYS_EDGECAPTURE(r12) /* Load KEY Edgecapture register */
        bne    r10,r13,POLL_KEY3 /* Poll for KEY3  */
        movi   r10,0b111
        stwio  r10,KEYS_EDGECAPTURE(r12)
        movi   r10,0b1000 /* STOP = 1 */
        stwio  r10,TIMER_CONTROL(r11) /* Stop Timer */
        movi   r10,0b0001
        stwio  r10,TIMER_STATUS(r11)
        ldhio  r10,TIMER_SNAPL(r11) /* Load lower timer period */
        andi   r10,r10,0XF /* Mask lower period with 0b1111 */
        beq    r10,r0,REPLACE_0 /* (Random number can't be 0) */
        movi   r13,0b1 /* Compare to 1 */
        beq    r10,r13,REPLACE_1 /* (Random number can't be 1) */

REPLACE_RETURN:
        movia  r13,RAND_NUM /* Load address of RAND_NUM */
        stwio  r10,(r13) /* Store random number */ 
        br     BEGIN_KEY3

REPLACE_0:
        addi   r10,r10,0x5 /* Replace 0 with 5 */
        br     REPLACE_RETURN /* Return to store num */

REPLACE_1:
        addi   r10,r10,0x9 /* Replace 1 with 9 */
        br     REPLACE_RETURN /* Return to store num */

BEGIN_KEY3:
        call   BLANK_7SEG_SUB /* Call BLANK_7SEG_SUB subroutine */
LEDR_DELAY:
        movia  r11,RAND_NUM
        ldwio  r12,(r11)
SEC_2_DELAY:
        movi   r14,0x2
        bne    r12,r14,SEC_3_DELAY
        movia  r11,SEC2_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_3_DELAY:
        movi   r14,0x3
        bne    r12,r14,SEC_4_DELAY
        movia  r11,SEC3_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_4_DELAY:
        movi   r14,0x4
        bne    r12,r14,SEC_5_DELAY
        movia  r11,SEC4_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_5_DELAY:
        movi   r14,0x5
        bne    r12,r14,SEC_6_DELAY
        movia  r11,SEC5_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_6_DELAY:
        movi   r14,0x6
        bne    r12,r14,SEC_7_DELAY
        movia  r11,SEC6_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_7_DELAY:
        movi   r14,0x7
        bne    r12,r14,SEC_8_DELAY
        movia  r11,SEC7_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_8_DELAY:
        movi   r14,0x8
        bne    r12,r14,SEC_9_DELAY
        movia  r11,SEC8_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_9_DELAY:
        movi   r14,0x9
        bne    r12,r14,SEC_10_DELAY
        movia  r11,SEC9_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_10_DELAY:
        movi   r14,0xA
        bne    r12,r14,SEC_11_DELAY
        movia  r11,SEC10_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_11_DELAY:
        movi   r14,0xB
        bne    r12,r14,SEC_12_DELAY
        movia  r11,SEC11_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_12_DELAY:
        movi   r14,0xC
        bne    r12,r14,SEC_13_DELAY
        movia  r11,SEC12_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_13_DELAY:
        movi   r14,0xD
        bne    r12,r14,SEC_14_DELAY
        movia  r11,SEC13_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_14_DELAY:
        movi   r14,0xE
        bne    r12,r14,SEC_15_DELAY
        movia  r11,SEC14_DELAY
        ldwio  r10,(r11)
        br     LOAD_DELAY
SEC_15_DELAY:
        movia  r11,SEC15_DELAY
        ldwio  r10,(r11)
LOAD_DELAY:
        movia  r11,TIMER /* Load TIMER address */
        mov    r12,r10
        /* Precautionary TIMER stop */
        movi   r10,0b1000 /* Stop bit high */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        
        /* Precautionary TO bit clearing */
        movi   r10,0b0001 /* TO bit high */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */
        
        /* Load period with random number */
        sthio  r12,TIMER_PERIODL(r11) /* Store low two bytes to PERIODL */
        srli   r12,r12,16 /* Loagical shift left 2 bytes */
        sthio  r12,TIMER_PERIODH(r11) /* Store high two bytes to PERIODH */
        
        /* Start Timer */
        movi   r10,0b0100
        stwio  r10,TIMER_CONTROL(r11)
        
        /* Poll KEY2 */
        movia  r12,KEYS
        movi   r13,0b010
        movi   r14,0b001
POLL_KEY2_OOPS:
        ldwio  r10,KEYS_EDGECAPTURE(r12)
        andi   r10,r10,0b111
        beq    r10,r13,DISPLAY_OOPS
POLL_RANDOM_TIMER:                    
        /* Poll TIMER*/
        ldwio  r10,TIMER_STATUS(r11)
        andi   r10,r10,0b0001
        beq    r10,r14,STOP_RANDOM_TIMER
        br     POLL_KEY2_OOPS

STOP_RANDOM_TIMER:
        movi   r10,0b1000 /* Stop bit high */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit high */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */
ZERO_7SEGDISPLAY:
        movi   r10,SEG7_O
        movi   r12,SEG7_O
        movia  r11,HEX3210
        slli   r10,r10,8
        or     r10,r10,r12
        slli   r10,r10,8
        or     r10,r10,r12
        slli   r10,r10,8
        or     r10,r10,r12
        stwio  r10,(r11)

        movia  r11,TIMER_500msDELAY
        ldwio  r10,(r11)
TIMER_1SEC_PERIOD:
        movia  r11,TIMER
        sthio  r10,TIMER_PERIODL(r11)
        srli   r10,r10,16
        sthio  r10,TIMER_PERIODH(r11)
LEDR_ON:
        movi   r10,0b0110
        movia  r11,LEDR
        stwio  r10,(r11)
        movia  r11,TIMER
TIMER_1SEC_START:
        movi   r10,0b0100
        stwio  r10,TIMER_CONTROL(r11)
        /* Poll KEY2 */
        movia  r12,KEYS
        movi   r13,0b010
        movi   r14,0b001
POLL_KEY2_1SEC:
        ldwio  r10,KEYS_EDGECAPTURE(r12)
        andi   r10,r10,0b111
        beq    r10,r13,DISPLAY_OOPS
POLL_TIMER_1SEC:
        ldwio  r10,TIMER_STATUS(r11)
        andi   r10,r10,0b1
        bne    r10,r14,POLL_KEY2_1SEC
TIMER_1SEC_STOP:
        movi   r10,0b1000
        stwio  r10,TIMER_CONTROL(r11)
LEDR_OFF: 
        movia  r11,LEDR
        stwio  r0,(r11)           
LOAD_1mSEC_TIMER:
        movia  r11,TIMER
        movia  r14,TIMER_1msDELAY
        ldwio  r12,(r14)
        /* Load period with random number */
        sthio  r12,TIMER_PERIODL(r11) /* Store low two bytes to PERIODL */
        srli   r12,r12,16 /* Loagical shift left 2 bytes */
        sthio  r12,TIMER_PERIODH(r11) /* Store high two bytes to PERIODH */
START_1mSEC_TIMER:
        movia  r11,TIMER
        movia  r12,KEYS
        movi   r10,0b0100
        stwio  r10,TIMER_CONTROL(r11)
        movi   r13,0b010
        movi   r14,0b001
POLL_KEY2_OUt:
        ldwio  r10,KEYS_EDGECAPTURE(r12)
        andi   r10,r10,0b1111
        beq    r10,r13,DISPLAY_WIN
POLL_1mSEC_TIMER:                    
        /* Poll TIMER*/
        ldwio  r10,TIMER_STATUS(r11)
        andi   r10,r10,0b0001
        beq    r10,r14,STOP_1mSEC_TIMER
        br     POLL_KEY2_OUt

STOP_1mSEC_TIMER:
        movia  r11,TIMER
        movi   r10,0b1000
        stwio  r10,TIMER_CONTROL(r11)
        movi   r10,0b0001
        stwio  r10,TIMER_STATUS(r11)
        addi   r17,r17,1 /* increment milliseconds counter */
        bne    r17,r19,CONVERT_NUM /* compare milliseconds to 100 */
        br     DISPLAY_OUt
CONVERT_NUM:
        /* Convert Milliseconds */
        mov   r4,r17 /* move milliseconds counter to subroutine input */
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
        
        /* Convert Seconds */
        mov   r4,r16 /* move seconds counter to subroutine input */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r7,r2 /* move ones place to r11 */
        mov   r6,r3 /* move tens place to r10 */
        mov   r4,r7 /* move ones place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r7,r2 /* move output back to r6 */
        mov   r4,r6 /* move tens place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r6,r2 /* move output back to r5 */

        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        br    START_1mSEC_TIMER

DISPLAY_OUt:
        movi   r10,0b1000 /* Stop bit high */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit high */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */

        movi   r10,BLANK7SEG /* Load 7-seg " "  */
        movia  r11,HEX7654 /* Load HEX7654 address */
        stwio  r10,(r11) /* Store to HEX7654 */
        movia  r11,HEX3210 /* Load HEX3210 address */
        movi   r10,HEXOFF /* Load 7-seg " " */
        movi   r12,SEG7_O /* Load 7-seg "O"  */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* add r12 to lower byte */
        movi   r12,SEG7_U /* Load 7-seg "U"  */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* add r12 to lower byte */ 
        movi   r12,SEG7_t /* Load 7-seg "t"  */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* add r12 to lower byte */
        stwio  r10,(r11) /* store to HEX3210 */

        br    END_PUSHBUTTON_ISR /* Exit PUSHBUTTON_ISR */

DISPLAY_OOPS:
        movi   r10,0b1000 /* Stop bit high */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit high */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */

        movi r10,BLANK7SEG /* Load 7-seg " " */
        movia  r11,HEX7654 /* Load HEX7654 address */
        stwio  r10,(r11) /* Store to HEX7654 */
        movia  r11,HEX3210 /* Load HEX3210 address */
        movi   r10,SEG7_O /* Load 7-seg "O"  */
        movi   r12,SEG7_O /* Load 7-seg "O"  */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* Add r12 to lower byte */
        movi   r12,SEG7_P /* Load 7-seg "P" */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* Add r12 to lower byte */ 
        movi   r12,SEG7_S /* Load 7-seg "S" */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* Add r12 to lower byte */
        stwio  r10,(r11) /* Store to HEX3210 */

        br    END_PUSHBUTTON_ISR /* Exit PUSHBUTTON_ISR */
DISPLAY_WIN:
        movia  r11,TIMER
        movia  r12,KEYS
        movi   r10,0b1000
        stwio  r10,TIMER_CONTROL(r11)
        movi   r10,0b0001
        stwio  r10,TIMER_STATUS(r11)
        movi   r10,0b1111
        stwio  r10,KEYS_EDGECAPTURE(r12)

        br    END_PUSHBUTTON_ISR /* Exit PUSHBUTTON_ISR */

/**************************************************************************
   SUBROUTINES
**************************************************************************/

DISPLAY_HELLO:
        nor    r12,r0,r0
        movi   r10,SEG7_H /* Load 7-seg "H" */
        slli   r12,r12,8
        or     r12,r12,r10
        movia  r11,HEX7654 /* Load HEX7654 address */
        stwio  r12,(r11) /* Store to HEX7654 */
        movia  r11,HEX3210 /* Load HEX3210 address */
        movi   r10,SEG7_E /* Load 7-seg "E"  */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        movi   r12,SEG7_L /* Load 7-seg "L"  */
        or     r10,r10,r12 /* Add r12 to lower byte */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* Add r12 to lower byte */
        movi   r12,SEG7_O /* Load 7-seg "O"  */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* Add r12 to lower byte */
        stwio  r10,(r11) /* Store to HEX3210 */
        ret /* exit subroutine */

/**************************************************************************/

CLEAR_LEDS:
        movia  r11,LEDR /* Load address of LEDs */
        stwio  r0,(r11) /* Turn off LEDs */
        ret /* exit subroutine */
/**************************************************************************/

BLANK_7SEG_SUB:
        nor   r10,r0,r0 /* Load 7-seg " " */
        movia r11,HEX7654 /* Load HEX7654 address */
        stwio r10,(r11) /* Turn off HEX7654 */
        movia r11,HEX3210 /* Load HEX3210 address */
        stwio r10,(r11) /* Turn off HEX3210 */
        ret /* exit subroutine */
/**************************************************************************/



/****************************************************************/

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

/****************************************************************/

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

/****************************************************************/

/*
   DISPLAY_3210 subroutine
   R17 holds address of HEX3210
   Input: r6,r7,r8,r9
          Tens_s,Ones_s,Tens_ms,Ones_ms
   Output: store r2 to 7-SEG
*/
DISPLAY_3210:
        movia  r3,HEX3210 /* load HEX3210 address */
        mov    r2,r6 /* move 10's seconds */
        slli   r2,r2,8 /* logical shift left 1 byte */
        or     r2,r2,r7 /* concatenate 1's seconds */
        slli   r2,r2,8 /* logical shift left 1 byte */
        or     r2,r2,r8 /* concatenate 10's milliseconds */
        slli   r2,r2,8 /* logical shift left 1 byte */
        or     r2,r2,r9 /* concatenate 1's milliseconds */
        stwio  r2,0(r3) /* store value to HEX3210 */
        ret /* exit subroutine *


/****************************************************************/

.end
