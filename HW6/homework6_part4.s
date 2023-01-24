/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 6 Part 4
*/

        .include "address_map.s"

		.text
        .global _start /* beginning of program */  

_start:      
        call  CONFIG_STACK
        call  INITIALIZE_COUNTER
        call  CONFIG_7SEG
        call  CONFIG_KEYS
        call  CONFIG_TIMER
        call  CONFIG_INTERRUPT

LOOP:
        br    LOOP /* Infinite Loop to wait for interrupts */

CONFIG_STACK:
        movia  sp,STACK_BASE /* Move STACK_BASE to stack pointer */
        ret /* return from subroutine */

HEXOFF:
        /* Turn off HEX7654 */
        movia  r3,HEX7654 /* Load address of HEX3210 */
        nor    r2,r0,r0 /* set r16 to FFFFFFFF */
        stwio  r2,0(r3) /* turn off HEX7654 */
        /* Initialize HEX3210 to zeros */
        movia  r3,BIT_CODES /* load BIT_CODES address */
        ldbuio r2,(r3) /* load 7-SEG 0 code */
        slli   r3,r2,8 /* logical shift left 1 byte */
        or     r3,r3,r2 /* or 7-SEG 0 code */
        slli   r3,r3,8 /* logical shift left 1 byte */
        or     r3,r3,r2 /* or 7-SEG 0 code */
        slli   r3,r3,8 /* logical shift left 1 byte */
        or     r3,r3,r2 /* or 7-SEG 0 code */
        movia  r2,HEX3210 /* load address of 7-seg displays */
        stwio  r3,(r2)  /* store 0000 to 7-seg displays */
        ret /* return from subroutine */

INITIALIZE_COUNTER: /* These registers remain unchanged throughout program */
        movi  r13,0x00 /* Timer on/off value */
        movia r14,TIMER /* move address of TIMER */
        movia r15,KEYS /* move address of KEYS */ 
        mov   r16,r0 /* initialize seconds counter to zero */
        mov   r17,r0 /* initialize milliseconds counter to zero */
        movi  r18,0x3C /* terminating seconds count value */
        movi  r19,0x64 /* terminating milliseconds count value */
        ret /* return from subroutine */

CONFIG_7SEG:
        movia r3,HEX7654 /* Load address of HEX7654 */
        nor   r2,r0,r0 /* set r11 to FFFFFFFF */
        stwio r2,0(r3) /* turn off HEX7654 */
        /* Initialize HEX3210 to zeros */
        movia  r3,BIT_CODES /* load BIT_CODES address */
        ldbuio r2,(r3) /* load 7-SEG 0 code */
        slli   r3,r2,8 /* logical shift left 1 byte */
        or     r3,r3,r2 /* or 7-SEG 0 code */
        slli   r3,r3,8 /* logical shift left 1 byte */
        or     r3,r3,r2 /* or 7-SEG 0 code */
        slli   r3,r3,8 /* logical shift left 1 byte */
        or     r3,r3,r2 /* or 7-SEG 0 code */
        movia  r2,HEX3210 /* load address of 7-seg displays */
        stwio  r3,(r2)  /* store 0000 to 7-seg displays */
        ret /* return from subroutine */

CONFIG_TIMER:
        /* Stop Timer */
        movia r3,TIMER /* Address of timer */
        movi  r2,0b1000 /* STOP bit for timer */
        stwio r2,TIMER_CONTROL(r3) /* Turn off timer */
        /* Set timer period 1/(50 MHz) × (0xBEBC20) = 0.25 sec*/
        movi  r2,0xA1 /* Move 0xBC to r12 */
        slli  r2,r2,8 /* Logical shift left 8 bits */
        addi  r2,r2,0x20 /* Add 0x20 to r12 */
        sthio r2,TIMER_PERIODL(r3) /* store the low halfword of counter start value */
        movi  r2,0x07 /* Move 0xBE to r12 */
        sthio r2,TIMER_PERIODH(r3) /* high halfword of counter start value */
        /* Start Timer */
        movi  r2,0b0111 /* START = 1, CONT = 1, ITO = 1 */
        stwio r2,TIMER_CONTROL(r3) /* Store value to timer control register */
        ret /* return from subroutine */

CONFIG_KEYS:
        movia r3,KEYS /* Load address of KEYS */
        movia r2,0b1111 /* KEY1, KEY2, and KEY3 */
        stwio r2,KEYS_EDGECAPTURE(r3) /* Clear Edgecapture Register */
        stwio r2,KEYS_INTMASK(r3) /* Store value to enable KEY interrupts */
        ret /* return from subroutine */

CONFIG_INTERRUPT:
        /* ctl4 */
        movi  r2,0b0011 /* IRQ 0 for TIMER, IRQ 1 for KEYS */
        wrctl ienable,r2 /* Enable IRQ1 for KEYS */
        /* ctl0 */
        movi  r2,0b0001 /* PIE bit enables external interrupts */
        wrctl status,r2  /* Write 1 to PIE bit */
        ret /* return from subroutine */

           .global BIT_CODES
BIT_CODES: .byte 0b11000000 /* 7-SEG code for 0 */
           .byte 0b11111001 /* 7-SEG code for 1 */
           .byte 0b10100100 /* 7-SEG code for 2 */
           .byte 0b10110000 /* 7-SEG code for 3 */
           .byte 0b10011001 /* 7-SEG code for 4 */
           .byte 0b10010010 /* 7-SEG code for 5 */
           .byte 0b10000010 /* 7-SEG code for 6 */
           .byte 0b11111000 /* 7-SEG code for 7 */
           .byte 0b10000000 /* 7-SEG code for 8 */
           .byte 0b10011000 /* 7-SEG code for 9 */

           .skip 2 /* pad with 2 bytes to maintain word alignment */

		   .end
