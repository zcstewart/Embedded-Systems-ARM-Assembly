/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 5 Part 3
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
        .equ TIMER_BASE,      0x202000 /* Address of Timer */
        .equ TIMER_STATUS,    0 /* Timer Status Register */
        .equ TIMER_CONTROL,   4 /* Timer Control Register */
        .equ TIMER_PERIODL,   8 /* Timer Period Low Register */
        .equ TIMER_PERIODH,   12 /* Timer Period High Register */
        .equ TIMER_SNAPL,     16 /* Timer Snapshot Low Register */
        .equ TIMER_SNAPH,     20 /* Timer Snapshot High Register */
        .equ KEYS_EDGE,       12 /* KEYS Edgecapture Register for */

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
        movia r21,KEYS /* load KEYS address */

INITIALIZE_TIMER:
TIMER_OFF:
        movia r11,TIMER_BASE /* move Timer base address to r11 */
        movi  r12,0b1000 /* value to turn off counter */
        stwio r12,TIMER_CONTROL(r11) /* turn off timer */
TIMEOUT_PERIOD:
        /* BEBC20 */
        movi  r8,0xBC /* byte 1 of counter value */
        slli  r8,r8,8 /* logical shift left 1 byte */
        ori   r8,r8,0x20 /* OR byte 0 of counter value */
        movi  r9,0xBE /* byte 2 of counter value */
        sthio r9,TIMER_PERIODH(r11) /* 0xBE to high period */
        sthio r8,TIMER_PERIODL(r11) /* 0xBC20 to low period */
TIMER_START:
        movi  r12,0b0100 /* START bit for timer */
        stbio r12,TIMER_CONTROL(r11) /* start TIMER */
POLL_TIMER:
        ldwio r22,KEYS_EDGE(r21) /* load KEYS Edgecapture  */
        andi  r22,r22,0xF /* mask last four bits */
        bne   r22,r0,KEY_STOP /* if pressed, stop timer */
RETURN:
        ldwio r12,TIMER_STATUS(r11) /* check Timer STATUS register */
        andi  r12,r12,0x1 /* Mask least-significant bit */
        beq   r12,r0,POLL_TIMER /* If still counting, check KEYS */
TIMER_STOP:
        mov   r23,ra /* save return address */
        call  INCREMENT_SUB /* call INCREMENT_SUB subroutine */
        mov   ra,r23 /* restore return address */
        movi  r12,0b0001 /* clear TO bit */
        stbio r12,TIMER_STATUS(r11) /* clear status register */
        br    TIMER_START  /* Branch to start timer */

KEY_STOP:
        movi  r12,0b1000 /* STOP bit for timer */
        stbio r12,TIMER_CONTROL(r11) /* stop Timer */
        movi  r22,0xF /* value to clear KEYS Edgecapture */
        stwio r22,KEYS_EDGE(r21) /* clear KEYS Edgecapture */
LOOP:
        ldwio r22,KEYS_EDGE(r21) /* load KEYS Edgecapture */
        andi  r22,r22,0xF /* mask last four bits */
        beq   r22,r0,LOOP /* If 0, wait for new KEY press */
        movi  r22,0xF /* value to clear KEYS Edgecapture */
        stwio r22,KEYS_EDGE(r21) /* clear KEYS Edgecapture */
        movi  r12,0b0100 /* START bit for timer */
        stbio r12,TIMER_CONTROL(r11) /* start timer */
        br    RETURN /* branch to check timer status */
/*

*/
INCREMENT_SUB:
        addi  r18,r18,1 /* increment counter */
        bne   r18,r19,CONVERT_NUM /*  */
        movi  r18,0 /*  */
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
