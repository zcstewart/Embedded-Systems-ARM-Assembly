/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 5 Part 2
*/
		.text
		.equ HEX3210,         0x202070 /* Address of HEX0 */
        .equ HEX7654,         0x202020 /* Address of HEX1 */
        .equ KEYS,            0x202050 /* Address of KEYS */
        .equ SWITCHES,        0x202060 /* Address of SWITCHES */
        .equ LEDR,            0x202030 /* Address of LEDR */
        .equ LEDG,            0x202040 /* Address of LEDG */
        .equ TIMER,           0x202000 /* Address of Timer */
        .equ HEX_OFF,         0b11111111 /* Turn off all segments */
        .equ KEYS_EDGE,       12 /* KEYS Edge-Capture Register for */

        .global _start /* beginning of program */  

_start:      
HEXOFF:
        movi  r4,0 /* DIVIDE subroutine input is 0 */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   r6,r2 /* move ones place to r6 */
        mov   r5,r3 /* move tens place to r5 */
        mov   r4,r6 /* move ones place to subroutine input */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   r6,r2 /* move output back to r6 */
        mov   r4,r5 /* move tens place to subroutine input */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   r5,r2 /* move output back to r5 */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        call  DISPLAY_7654 /* call DISPLAY_3210 subroutine */
INITIALIZE_COUNTER:
        mov   r18,r0 /* initialize counter to zero */
        movi  r19,0x64 /* terminating count value */
        movia r21,KEYS /* addr of KEYS */

INITIALIZE_DELAY:
        movi  r12,0x16E /* upper 3 bytes of counter */
        slli  r12,r12,12 /* logical shift left 3 bytes */
        ori   r12,r12,0x360 /* lower 3 bytes of counter */
DELAY_LOOP:
        ldwio r22,KEYS_EDGE(r21) /* load KEYS edgecapture */
        andi  r22,r22,0xF /* mask last 4 bits */
        bne   r22,r0,KEY_STOP /* no key pressed? stop timer */
RETURN:
        subi  r12,r12,1 /* decrement delay value */
        bne   r12,r0,DELAY_LOOP /* if counter not zero, repeat */
TIMER_STOP:
        mov   r23,ra /* save return address */
        call  INCREMENT_SUB /* call INCREMENT_SUB subroutine */
        mov   ra,r23 /* restore return address */
        br    INITIALIZE_DELAY /* branch to restart delay */
KEY_STOP:
        movi  r22,0xF /* value to clear edgecapture */
        stwio r22,KEYS_EDGE(r21) /* clear edgecapture register */
LOOP:
        ldwio r22,KEYS_EDGE(r21) /* load KEYS edgecapture */
        andi  r22,r22,0xF /* mask last 4 bits */
        beq   r22,r0,LOOP /* no key pressed? wait for press */
        movi  r22,0xF /* value to clear edgecapture */
        stwio r22,KEYS_EDGE(r21) /* clear edgecapture */
        br    RETURN /* continue delay */
/*

*/
INCREMENT_SUB:
        addi  r18,r18,1 /* increment counter */
        bne   r18,r19,CONVERT_NUM /* counter not 100? display */
        movi  r18,0 /* reset counter if 100 */
CONVERT_NUM:
        mov   r4,r18 /* move counter to subroutine input */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r6,r2 /* move ones place to r6 */
        mov   r5,r3 /* move tens place to r5 */
        mov   r4,r6 /* move ones place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r6,r2 /* move output back to r6 */
        mov   r4,r5 /* move tens place to subroutine input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r5,r2 /* move output back to r5 */
        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        ret /* exit subroutine */

/* 
   DIVIDE subroutine
   r2 holds one's place number, r3 holds tens place number */
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
         movia  r15, BIT_CODES /* load bitcodes to r15 */
         add    r15, r15, r4 /* add number as byte offset */
         ldbuio r2, (r15) /* load 7-seg value */
         ret /* exit subroutine */

/*
   DISPLAY_3210 subroutine
   input, r10
*/
DISPLAY_3210:
        movia r17,HEX3210 /* Load address of HEX3210 */
        movi  r16,HEX_OFF /* turn off byte 3 */
        slli  r16,r16,8 /* logical shift left, 8-bits */
        addi  r16,r16,HEX_OFF /* turn off byte 2 */
        slli  r16,r16,8 /* logical shift left, 8-bits */
        or    r16,r16,r5 /* move r5 to byte 1 */
        slli  r16,r16,8 /* logical shift left, 8-bits */
        or    r16,r16,r6 /* move r4 to byte 0 */
        stwio r16,0(r17) /*store value to HEX3210  */
        ret /* exit subroutine */
/*
   DISPLAY_7654 subroutine
   input, r10
*/
DISPLAY_7654:
        movia r17,HEX7654 /* Load address of HEX3210 */
        nor   r16,r0,r0 /* set r16 to FFFFFFFF */
        stwio r16,0(r17) /* turn off HEX7654 */
        ret /* exit subroutine */

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
