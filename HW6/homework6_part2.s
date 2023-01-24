/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 6 Part 2
*/
		.text

        .include "address_map.s"        

        .global _start /* beginning of program */  

_start:
        call   CONFIG_STACK /* call CONFIG_STACK subroutine */
        call   CONFIG_7SEG /* call CONFIG_7SEG subroutine */
        call   CONFIG_KEYS /* call CONFIG_KEYS subroutine */
        call   CONFIG_INTERRUPT /* call CONFIG_INTERRUPT */
        call   CONFIG_TIMER /* call CONFIG_TIMER */

LOOP:   movia r8,LEDR /* Load address of LEDR */
        movia r3,COUNT /* Load address of COUNT value */
        ldwio r9,(r3) /* Global variable */
        stwio r9,(r8) /* Store count value to LEDS */
        br LOOP /* Branch to LOOP top */


CONFIG_STACK:
        movia  sp,STACK_BASE /* Move STACK_BASE to stack pointer */
        ret /* Return from subroutine */
CONFIG_7SEG:
        movia r10,HEX7654 /* Load address of HEX7654 */
        nor   r11,r0,r0 /* set r11 to FFFFFFFF */
        stwio r11,0(r10) /* turn off HEX7654 */
        movia r10,HEX3210 /* Load address of HEX3210 */
        nor   r11,r0,r0 /* set r11 to FFFFFFFF */
        stwio r11,0(r10) /* turn off HEX3210 */
        ret /* Return from subroutine */
CONFIG_TIMER:
        /* Stop Timer */
        movia r16,TIMER /* Address of timer */
        movi  r11,0b1000 /* STOP bit for timer */
        stwio r11,TIMER_CONTROL(r16) /* Turn off timer */
        /* Set timer period */
        movi  r12,0xBC /* 1/(50 MHz) × (0xBEBC20) = 0.25 sec */
        slli  r12,r12,8 /* Logic Shift Left */
        addi  r12,r12,0x20 /* Move 0xBC20 to TIMER_PERIODL */
        sthio r12,TIMER_PERIODL(r16) /* store the low halfword of counter start value */
        movi  r12,0xBE /* Move 0xBE to TIMER_PERIODH */
        sthio r12,TIMER_PERIODH(r16) /* high halfword of counter start value */
        /* Start Timer */
        movi  r12,0b0111 /* START = 1, CONT = 1, ITO = 1 */
        stwio r12,TIMER_CONTROL(r16) /* Store value to timer control register */
        ret /* Return from subroutine */

CONFIG_KEYS:
        movia r10,KEYS /* Load address of KEYS */
        movia r11,0b1111 /* KEY1, KEY2, and KEY3 */
        stwio r11,KEYS_EDGECAPTURE(r10) /* Clear Edgecapture Register */
        movia r11,0b1111 /* Value to enable KEY1, KEY2, and KEY3 interrupts */
        stwio r11,KEYS_INTMASK(r10) /* Store value to enable KEY interrupts */
        ret /* Return from subroutine */
CONFIG_INTERRUPT:
        /* ctl4 */
        movi  r11,0b0011 /* IRQ 0 for TIMER, IRQ 1 for KEYS */
        wrctl ienable,r11 /* Enable IRQ1 for KEYS */
        /* ctl0 */
        movi  r11,0b0001 /* PIE bit enables external interrupts */
        wrctl status,r11  /* Write 1 to PIE bit */
        ret /* Return from subroutine */

        .data

        .global COUNT
COUNT:  .word 0x0 /* used by timer */

        .global RUN
RUN:    .word 0x0 /* used by KEYS to increment COUNT */

		.end

