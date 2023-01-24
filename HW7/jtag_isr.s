/********************************************************************************
* Pushbutton - Interrupt Service Routine

  KEY1: "CLEAR"

  KEY2: "STOP"

  KEY3: "START"
********************************************************************************/
        .include "address_map.s"

        .global JTAG_ISR

JTAG_ISR:
        subi  sp,sp,24 /* Subtract 5 bytes from stack pointer */
        stwio ra,0(sp) /* Store return address to stack pointer */
        stwio r10,4(sp) /* Store r10 to stack pointer */
        stwio r11,8(sp) /* Store r11 to stack pointer */
        stwio r12,12(sp) /* Store r12 to stack pointer */
        stwio r13,16(sp) /* Store r13 to stack pointer */
        stwio r14,20(sp) /* Store r14 to stack pointer */

        movia r10,JTAG_UART /* Base address of pushbutton KEY parallel port */
        movi  r12,0x400 /* Clear AC Bit, Disable read interrupts */
        stwio r12,JTAG_CONTROL(r10)
CHECK_KEYC:
        ldwio r11,JTAG_DATA(r10) /* Read edge capture register */
        andi  r13,r11,0x8000 /* Check KEYC RVALID */
        beq   r13,r0,CHECK_KEYC /* If not valid, check again */
        andi  r13,r11,0x00FF /* Mask data with low byte */
        beq   r13,r17,KEYC_ROUTINE /* If key C, enter routine */
        br    END_JTAG_ISR /* Exit JTAG_ISr */
END_JTAG_ISR:
        movia r12,JTAG_UART /* Load address of JTAG_UART */
        movi  r10,0x401 /* Clear AC Bit, Enable read interrupts */
        stwio r10,JTAG_CONTROL(r12) /* Store to JTAG_CONTROL register */
        ldwio ra,0(sp) /* Restore return address from stack */
        ldwio r10,4(sp) /* Restore r10 from stack */
        ldwio r11,8(sp) /* Restore r11 from stack */
        ldwio r12,12(sp) /* Restore r12 from stack */
        ldwio r13,16(sp) /* Restore r13 from stack */
        ldwio r14,20(sp) /* Restore r14 from stack */
        addi  sp,sp,24 /* Add 5 bytes to stack pointer address */
        ret /* Return from JTAG_ISR */

/* CLEAR KEY = KEY 1 */
KEYC_ROUTINE:
        mov   r15,r0 /* initialize milliseconds counter to zero */
BEGIN_KEYC:
        call  DISPLAY_HELLO /* Call DISPLAY_HELLO subroutine */
        call  CLEAR_LEDS /* Call CLEAR_LEDS subroutine */
RAND_TIMER_SEED:
        movia  r11,TIMER /* Load TIMER address */
        movi   r10,0b1000 /* Stop bit high */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit high */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */
        movia  r14,TIMER_2sDELAY /* Load 2 second delay value */
        ldwio  r10,(r14) /* Load 2 second delay */
        sthio  r10,TIMER_PERIODL(r11) /* Store low two bytes to PERIODL */
        srli   r10,r10,16 /* Loagical shift left 2 bytes */
        sthio  r10,TIMER_PERIODH(r11) /* Store high two bytes to PERIODH */
        movi   r10,0b0110 /* START = 1, CONT = 1, ITO = 0 */
        stwio  r10,TIMER_CONTROL(r11) /* Store value to control register */
        movia  r12,JTAG_UART /* Load address of JTAG_UART */
        movi   r13,0x0400 /* AC bit */
        stwio  r13,JTAG_CONTROL(r12) /* Clear AC bit */
POLL_KEY_S:
        ldwio  r10,JTAG_DATA(r12) /* Load KEY Edgecapture register */
        andi   r13,r10,0x8000 /* Mask RVALID */
        beq    r13,r0,POLL_KEY_S /* If not valid, check again */
        andi   r13,r10,0x00FF /* Mask lower byte */
        beq    r13,r18,KEY_S_PRESSED /* If key s pressed, branch */
        movi   r13,0x0400 /* AC bit */
        stwio  r13,JTAG_CONTROL(r12) /* Clear AC bit */
        br     POLL_KEY_S /* Poll S key */
KEY_S_PRESSED:
        movi   r10,0b1000 /* STOP = 1 */
        stwio  r10,TIMER_CONTROL(r11) /* Stop Timer */
        movi   r10,0b0001 /* TO bit */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */
        ldhio  r10,TIMER_SNAPL(r11) /* Load lower timer period */
        andi   r10,r10,0XF /* Mask lower period with 0b1111 */
        beq    r10,r0,REPLACE_0 /* (Random number can't be 0) */
        movi   r13,0b1 /* Compare to 1 */
        beq    r10,r13,REPLACE_1 /* (Random number can't be 1) */

REPLACE_RETURN:
        movia  r13,RAND_NUM /* Load address of RAND_NUM */
        stwio  r10,(r13) /* Store random number */ 
        br     BEGIN_KEY_S /* Branch to BEGIN_KEY_S */

REPLACE_0:
        addi   r10,r10,0x5 /* Replace 0 with 5 */
        br     REPLACE_RETURN /* Return to store num */

REPLACE_1:
        addi   r10,r10,0x9 /* Replace 1 with 9 */
        br     REPLACE_RETURN /* Return to store num */

BEGIN_KEY_S:
        call   BLANK_7SEG_SUB /* Call BLANK_7SEG_SUB subroutine */
LEDR_DELAY:
        movia  r11,RAND_NUM /* Load random number address */
        ldwio  r12,(r11) /* Load random number to 12 */
SEC_2_DELAY:
        movi   r14,0x2 /* Check for 2 */
        bne    r12,r14,SEC_3_DELAY /* Check next number */
        movia  r11,SEC2_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_3_DELAY:
        movi   r14,0x3 /* Check for 3 */
        bne    r12,r14,SEC_4_DELAY /* Check next number */
        movia  r11,SEC3_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_4_DELAY:
        movi   r14,0x4 /* Check for 4 */
        bne    r12,r14,SEC_5_DELAY /* Check next number */
        movia  r11,SEC4_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_5_DELAY:
        movi   r14,0x5 /* Check for 5 */
        bne    r12,r14,SEC_6_DELAY /* Check next number */
        movia  r11,SEC5_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_6_DELAY:
        movi   r14,0x6 /* Check for 6 */
        bne    r12,r14,SEC_7_DELAY /* Check next number */
        movia  r11,SEC6_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_7_DELAY:
        movi   r14,0x7 /* Check for 7 */
        bne    r12,r14,SEC_8_DELAY /* Check next number */
        movia  r11,SEC7_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_8_DELAY:
        movi   r14,0x8 /* Check for 8 */
        bne    r12,r14,SEC_9_DELAY /* Check next number */
        movia  r11,SEC8_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_9_DELAY:
        movi   r14,0x9 /* Check for 9 */
        bne    r12,r14,SEC_10_DELAY /* Check next number */
        movia  r11,SEC9_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_10_DELAY:
        movi   r14,0xA /* Check for 10 */
        bne    r12,r14,SEC_11_DELAY /* Check next number */
        movia  r11,SEC10_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_11_DELAY:
        movi   r14,0xB /* Check for 11 */
        bne    r12,r14,SEC_12_DELAY /* Check next number */
        movia  r11,SEC11_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_12_DELAY:
        movi   r14,0xC /* Check for 12 */
        bne    r12,r14,SEC_13_DELAY /* Check next number */
        movia  r11,SEC12_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_13_DELAY:
        movi   r14,0xD /* Check for 13 */
        bne    r12,r14,SEC_14_DELAY /* Check next number */
        movia  r11,SEC13_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_14_DELAY:
        movi   r14,0xE /* Check for 14 */
        bne    r12,r14,SEC_15_DELAY /* Check next number */
        movia  r11,SEC14_DELAY /* Load delay address */
        ldwio  r10,(r11) /* Load delay value */
        br     LOAD_DELAY /* Branch to LOAD_DELAY */
SEC_15_DELAY:
        movia  r11,SEC15_DELAY /* Otherwise, set to 15 */
        ldwio  r10,(r11) /* Load delay value */
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
        movi   r10,0b0100 /* START bit */
        stwio  r10,TIMER_CONTROL(r11) /* Start TIMER */
        
        /* Poll KEY_P */
        movia  r12,JTAG_UART /* Load address of JTAG_UART */
        movi   r14,1 /* Move 1 to r14 */
POLL_KEY_P_OOPS:
        ldwio  r10,JTAG_DATA(r12) /* Load JTAG_DATA */
        andi   r13,r10,0x8000 /* Mask RVALID */
        beq    r13,r0,POLL_RANDOM_TIMER /* Poll key P if not valid */
        andi   r13,r10,0x00FF /* Mask lower byte */
        beq    r13,r19,DISPLAY_OOPS /* Oops if pressed too soon */
POLL_RANDOM_TIMER:                    
        /* Poll TIMER*/
        ldwio  r10,TIMER_STATUS(r11) /* Load Timer Status */
        andi   r10,r10,0b0001 /* Mask TO bit */
        beq    r10,r14,STOP_RANDOM_TIMER /* If 1 stop timer */
        br     POLL_KEY_P_OOPS /* Poll key P */

STOP_RANDOM_TIMER:
        movi   r10,0b1000 /* Stop bit high */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit high */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */

        movia  r11,TIMER_200msDELAY /* 200ms delay address */
        ldwio  r10,(r11) /* Load 200ms delay */
TIMER_LED_PERIOD:
        movia  r11,TIMER /* Load TIMER address */
        sthio  r10,TIMER_PERIODL(r11) /* Store low period */
        srli   r10,r10,16 /* Logical shift left 2 bytes */
        sthio  r10,TIMER_PERIODH(r11) /* Store high period */
LEDR_ON:
        movi   r10,0b0110 /* Illuminate LEDR1 and LEDR2 */
        movia  r11,LEDR /* Load LEDR address */
        stwio  r10,(r11) /* Turn on */
        movia  r11,TIMER /* Load TIMER address */
TIMER_LED_START:
        movi   r14,0b1 /* Move 1 to r14 */
        movi   r10,0b0100 /* START bit */
        stwio  r10,TIMER_CONTROL(r11) /* Start timer */
        /* Poll KEY_P */
        movia  r12,JTAG_UART /* Load address of JTAG_UART */
        movi   r10,0x400 /* Clear AC Bit, Disable Read interrupts */
        stwio  r10,JTAG_CONTROL(r12) /* Clear AC bit */
POLL_KEY_P_1SEC:
        ldwio  r10,JTAG_DATA(r12) /* Load JTAG_DATA */
        andi   r13,r10,0x8000 /* Mask RAVAIL */
        beq    r13,r0,POLL_TIMER_1SEC /* Poll key P  */
        andi   r13,r10,0x00FF /* Masky lower byte */
        beq    r13,r19,DISPLAY_OOPS  /* Display OOPS if pressed */
POLL_TIMER_1SEC:
        ldwio  r10,TIMER_STATUS(r11) /* Load TIMER status */
        andi   r10,r10,0b1 /* Mask TO bit */
        bne    r10,r14,POLL_KEY_P_1SEC /* Poll key P if still counting */
TIMER_1SEC_STOP:
        movi   r10,0b1000 /* STOP bit */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
LEDR_OFF: 
        movia  r11,LEDR /* Load LEDR address */
        stwio  r0,(r11) /* Turn off LEDR */
ZERO_7SEGDISPLAY:
        movi   r10,SEG7_O /* 7-seg value: 0 */
        movi   r12,SEG7_O /* 7-seg value: 0 */
        movia  r11,HEX3210 /* Load HEX3210 address */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* OR r12 */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* OR r12 */
        slli   r10,r10,8 /* Logical shift left 1 byte */
        or     r10,r10,r12 /* OR r12 */
        stwio  r10,(r11) /* Store 0000 to HEX3210 */        
LOAD_1mSEC_TIMER:
        movia  r11,TIMER /* Load TIMER address */
        movia  r14,TIMER_1msDELAY /* Load 1ms delay address */
        ldwio  r12,(r14) /* Load 1ms delay */
        /* Load period with random number */
        sthio  r12,TIMER_PERIODL(r11) /* Store low two bytes to PERIODL */
        srli   r12,r12,16 /* Loagical shift left 2 bytes */
        sthio  r12,TIMER_PERIODH(r11) /* Store high two bytes to PERIODH */
START_1mSEC_TIMER:
        movia  r11,TIMER /* Load TIMER address */
        movi   r10,0b0100 /* START bit */
        stwio  r10,TIMER_CONTROL(r11) /* Start timer */
        movi   r14,0b001 /* Move 1 to r14 */
        movia  r12,JTAG_UART /* Load address of JTAG_UART */
POLL_KEY_P_OUt:
        ldwio  r10,JTAG_DATA(r12) /* Load JTAG_DATA */
        andi   r13,r10,0x8000 /* RVALID bit */
        beq    r13,r0,POLL_1mSEC_TIMER /* Poll key P */
        andi   r13,r10,0x00FF /* Mask lower 2 bytes */
        beq    r13,r19,DISPLAY_WIN /* If pressed, stop timer */
POLL_1mSEC_TIMER:                    
        /* Poll TIMER*/
        ldwio  r10,TIMER_STATUS(r11) /* Load TIMER status register */
        andi   r10,r10,0b0001 /* AND with 0b0001 */
        beq    r10,r14,STOP_1mSEC_TIMER /* If 1, stop timer */
        br     POLL_KEY_P_OUt /* Otherwise poll key P */

STOP_1mSEC_TIMER:
        movia  r11,TIMER /* Load TIMER address */
        movi   r10,0b1000 /* STOP bit */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */
        addi   r15,r15,1 /* increment milliseconds counter */
        bne    r15,r16,CONVERT_NUM /* compare milliseconds to 100 */
        br     DISPLAY_OUt /* Branch to display OUt */
CONVERT_NUM:
        /* Convert Milliseconds */
        mov   r5,r15 /* move milliseconds counter to subroutine input */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r9,r2 /* move ones place to r9 */
        mov   r8,r3 /* move tens place to r8 */
        mov   r7,r4 /* move one hundreds place to r7 */
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
        mov   r4,r7 /* move one hundreds place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r7,r2 /* move output back to r5 */

        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        br    START_1mSEC_TIMER /* branch to start 1ms timer */

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

        br    END_JTAG_ISR /* Exit JTAG_ISR */

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

        br    END_JTAG_ISR /* Exit JTAG_ISR */
DISPLAY_WIN:
        movia  r11,TIMER /* Load TIMER address */
        movi   r10,0b1000 /* STOP bit */
        stwio  r10,TIMER_CONTROL(r11) /* Stop TIMER */
        movi   r10,0b0001 /* TO bit */
        stwio  r10,TIMER_STATUS(r11) /* Clear TO bit */

        br    END_JTAG_ISR /* Exit JTAG_ISR */

/**************************************************************************
   SUBROUTINES
**************************************************************************/

DISPLAY_HELLO:
        movi   r10,HEXOFF /* 7-seg value " " */
        movi   r12,HEXOFF /* 7-seg value " " */
        slli   r12,r12,8 /* Logical shift left 1 byte */
        or     r12,r12,r10 /* Add r10 to lower byte */
        slli   r12,r12,8 /* Logical shift left 1 byte */
        or     r12,r12,r10 /* Add r10 to lower byte */
        movi   r10,SEG7_H /* Load 7-seg "H" */
        slli   r12,r12,8 /* Logical shift left 1 byte */
        or     r12,r12,r10 /* Add r10 to lower byte */
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

/* 
   DIVIDE subroutine
   r2 holds one's place number, r3 holds tens place number 
   r4 holds hundred's place number
   r5 is subroutine input
*/
DIVIDE:
DIVIDE_HUNDREDS:
         mov   r2,r5 /* Move contents of r5 to r2 */
		 movi  r6,100 /* Move immediate value of 10 to r6 */
		 movi  r3,0 /* Move immediate value of zero to r3 */
CONT_HUNDREDS:    
         blt   r2,r6,DIVIDE_TENS /* If r2 < r6, branch to DIV_TENS */
		 sub   r2,r2,r6 /* Subtract r6 from r2, store in r2 */
		 addi  r3,r3,1 /* Add 1 to r3, store in r3 */
		 br    CONT_HUNDREDS /* Branch program execution to CONT_HUNDREDS */
DIVIDE_TENS:  
         mov   r4,r3 /* Move r3 to r4 to save values */
		 movi  r6,10 /* Move immediate value of 10 to r5 */
		 movi  r3,0 /* Move immediate value of zero to r3 */
CONT:    blt   r2,r6,DIV_END /* If r2 < r5, branch to DIV_END */
		 sub   r2,r2,r6 /* Subtract r6 from r2, store in r2 */
		 addi  r3,r3,1 /* Add 1 to r3, store in r3 */
		 br    CONT /* Branch program execution to CONT */
DIV_END: 
         ret /* exit subroutine */ 
/****************************************************************/

/*
   SEG7_CODE subroutine
   Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
   Parameters: r4 = the decimal value of the digit to be displayed
   Returns: r2 = bit pattern to be written to the HEX display
*/
SEG7_CODE: 
         movia  r3, BIT_CODES /* load bitcodes to r3 */
         add    r3, r3, r4 /* add number as byte offset */
         ldbuio r2, (r3) /* load 7-seg value */
         ret /* exit subroutine */
/****************************************************************/

/*
   DISPLAY_3210 subroutine
   R15 holds number
   Input: r6,r7,r8,r9
          Tens_s,Ones_s,Tens_ms,Ones_ms
   Output: store r2 to 7-SEG
*/
DISPLAY_3210:
        movia  r3,HEX3210 /* load HEX3210 address */
        movi   r2,HEXOFF /* move 10's seconds */
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
