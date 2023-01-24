/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 5 Part 4
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
        .equ KEYS_EDGE,       12 /* KEYS Edge-Capture Register for */

        .global _start /* beginning of program */  

_start:      
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

INITIALIZE_COUNTER:
        mov   r16,r0 /* initialize seconds counter to zero */
        mov   r17,r0 /* initialize milliseconds counter to zero */
        movi  r18,0x3C /* terminating seconds count value */
        movi  r19,0x64 /* terminating milliseconds count value */
        movia r21,KEYS /* move address of KEYS */ 

INITIALIZE_TIMER:
TIMER_OFF:
        movia r15,TIMER_BASE /* move Timer base address to r11 */
        movi  r12,0b1000 /* value to turn off counter */
        stwio r12,TIMER_CONTROL(r15) /* turn off timer */
TIMEOUT_PERIOD:
        /* BEBC20 */
        movi  r13,0xA1 /* Move A1 to byte 1 */
        slli  r13,r13,8 /* logical shift left 1 byte */
        ori   r13,r13,0x20 /* concatenate 0x20 to byte 0 */
        movi  r14,0x07 /* Move 0x07 to byte 2 */
        sthio r14,TIMER_PERIODH(r15) /* 0xBE to high period */
        sthio r13,TIMER_PERIODL(r15) /* 0xBC20 to low period */

TIMER_START:
        movi  r12,0b0100 /* START bit for timer */
        stbio r12,TIMER_CONTROL(r15) /* timer control reg addr */
POLL_TIMER:
        ldwio r22,KEYS_EDGE(r21) /* keys edgecapture reg addr */
        andi  r22,r22,0xF /* mask last 4 bits */
        bne   r22,r0,KEY_STOP /* stop timer if KEY pressed */
RETURN:
        ldbio r12,TIMER_STATUS(r15) /* timer status reg addr */
        andi  r12,r12,0x1 /* mask last bit */
        beq   r12,r0,POLL_TIMER /* timer still active? keep polling */
TIMER_STOP:
        mov   r23,ra /* save return address */
        call  INCREMENT_SUB /* call INCREMENT_SUB subroutine */
        mov   ra,r23 /* restore return address */
        movi  r12,0b0000 /* clear TO bit */
        stbio r12,TIMER_STATUS(r15) /* clear status register */
        br    TIMER_START  /* branch to start timer */

KEY_STOP:
        movi  r12,0b1000 /* STOP bit for timer */
        stbio r12,TIMER_CONTROL(r15) /* timer control reg addr */
        movi  r22,0xF /* value to clear edgecapture */
        stwio r22,KEYS_EDGE(r21) /* clear edgecapture register */
LOOP:
        ldwio r22,KEYS_EDGE(r21) /* load edgecapture reg contents */
        andi  r22,r22,0xF /* mask last 4 bits */
        beq   r22,r0,LOOP /* if no KEY pressed, wait for press */
        movi  r22,0xF /* value to clear edgecapture */
        stwio r22,KEYS_EDGE(r21) /* clear KEYS edgecapture */
        movi  r12,0b0100 /* START bit for timer */
        stbio r12,TIMER_CONTROL(r15) /* START timer */
        br    RETURN /* branch to check keys */
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
        ret /* exit subroutine */

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
