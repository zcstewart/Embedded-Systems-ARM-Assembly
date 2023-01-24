/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 5 Part 1
*/
		.text
		.equ HEX3210,     0x202070 /* Address of HEX0 */
        .equ HEX7654,     0x202020 /* Address of HEX1 */
        .equ KEYS,        0x202050 /* Address of KEYS */
        .equ SWITCHES,    0x202060 /* Address of SWITCHES */
        .equ LEDR,        0x202030 /* Address of LEDR */
        .equ LEDG,        0x202040 /* Address of LEDG */
        .equ HEX_OFF,     0b11111111 /* Turn off all segments */

        .global _start /* Beginning of program */

_start:
        /* 
           7-Segment Displays are common anode, must write 1 to 
           turn off each segment
        */
HEXOFF:
        movi r20,0b1111 /* Value to test if KEYS are off */
        movi r4,0 /* DIVIDE subroutine input is 0 */
        call DIVIDE /* call DIVIDE subroutine */
        mov  r4,r2 /* move output to input */
        call SEG7_CODE /* call SEG7_CODE subroutine */
        mov  r4,r2 /* move output to input */
        call DISPLAY_7654 /* call DISPLAY_7654 subroutine */
        call DISPLAY_3210 /* call DISPLAY_3210 subroutine */
INITIALIZE:
        movi  r6,0b1110 /* value for KEY1 */
        movi  r7,0b1101 /* value for KEY2 */
        movi  r8,0b1011 /* value for KEY3 */
        movi  r9,0b0111 /* value for KEY4 */
        movi  r10,0 /* initialize counter to zero */
        movia r11,KEYS /* address of KEYS in r11 */
KEYREAD:
        ldwio r12,0(r11) /* read contents of KEYS */
        beq   r12,r20,KEYREAD /* check for no KEYS pressed */
        beq   r12,r6,KEY0  /* check for first KEY */
        beq   r12,r7,KEY1 /* check for second KEY */
        beq   r12,r8,KEY2 /* check for third KEY */
        beq   r12,r9,KEY3 /* check for fourth KEY */
        br    KEYREAD /* enter KEYREAD subroutine */
KEY0:
        mov   r23,ra /* save return address */
        call  ZERODISP /* call ZERODISP subroutine */
        mov   ra,r23 /* restore return address */
        br    KEYREAD /* branch to check KEYS */
KEY1:
        mov   r23,ra /* save return address */
        call  INCREMENT /* call INCREMENT subroutine */
        mov   ra,r23 /* restore return address */
        br    KEYREAD /* branch to check KEYS */
KEY2:
        mov   r23,ra /* save return address */
        call  DECREMENT /* call DECREMENT subroutine */
        mov   ra,r23 /* restore return address */
        br    KEYREAD /* branch to check KEYS */
KEY3:
        mov   r23,ra /* save return address */
        call  BLANKDISP /* call BLANKDISP subroutine */
        mov   ra,r23 /* restore return address */
        br    KEYREAD /* branch to check KEYS */

/*
   This subroutine will increment the current value of count
   and display it on HEX0, while HEX3, HEX2, HEX1 are blank     
*/
INCREMENT:
        ldbio r12,0(r11) /* load contents of KEYS */
        bne   r12,r20,INCREMENT /* wait for KEY to be released */
        addi  r10,r10,1 /* increment counter */
        mov   r4,r10 /* move counter to subroutine input */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r4,r2 /* move output to input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r4,r2 /* move output to input */
        mov   r23,ra /* save return address */
        call  DISPLAY_7654 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        ret /* exit subroutine */
/*
   This subroutine will decrement the current value of count
   and display it on HEX0, while HEX3, HEX2, HEX1 are blank
   if zero, the display won't be decremented further
*/
DECREMENT:
        ldbio r12,0(r11) /* load contents of KEYS */
        bne   r12,r20,DECREMENT /* wait for KEY to be released */
        beq   r10,r0,SKIP /* if counter == 0, don't subtract */
        subi  r10,r10,1 /* decrement counter by one */
SKIP:
        mov   r4,r10 /* move counter to subroutine input */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r4,r2 /* move output to input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r4,r2 /* move output to input */
        mov   r23,ra /* save return address */
        call  DISPLAY_7654 /* call DISPLAY_7654 subroutine */
        mov   ra,r23 /* restore return address */
        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        ret /* exit subroutine */
/*
   This subroutine will blank all the displays of HEX4, HEX3
   HEX2, and HEX1. Count reset to zero
*/
BLANKDISP:
        ldbio r12,0(r11) /* load contents of KEYS */
        bne   r12,r20,BLANKDISP /* wait for KEY to be released */
        movi  r4,HEX_OFF /* subroutine input clears all displays */
        mov   r23,ra /* save return address */
        call  DISPLAY_7654 /* call DISPLAY_7654 subroutine */
        mov   ra,r23 /* restore return address */
        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* call DISPLAY_3210 subroutine */
        mov   ra,r23 /* restore return address */
        movi  r10,0 /* reset counter to zero */
        ret /* exit subroutine */
/*
   This subroutine will blank HEX4, HEX3, HEX2, and show 
   the zero on HEX1. Count reset to zero
*/
ZERODISP:
        ldbio r12,0(r11) /* load contents of KEYS */
        bne   r12,r20,ZERODISP /* wait for KEY to be released */
        movi  r4,0 /* set subroutine input to zero */
        mov   r23,ra /* save return address */
        call  DIVIDE /* call DIVIDE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r4,r2 /* move output to input */
        mov   r23,ra /* save return address */
        call  SEG7_CODE /* call SEG7_CODE subroutine */
        mov   ra,r23 /* restore return address */
        mov   r4,r2 /* move output to input */
        mov   r23,ra /* save return address */
        call  DISPLAY_7654 /* call DISPLAY_7654 subroutine */
        mov   ra,r23 /* restore return address */
        mov   r23,ra /* save return address */
        call  DISPLAY_3210 /* restore return address */
        mov   ra,r23 /* restore return address */
        movi  r10,0 /* reset counter to zero */
        ret /* exit subroutine */
/* 
   DIVIDE subroutine
   input: r4
   outputs: r2 (one's place number) r3 (tens place number) 
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
         movia r15, BIT_CODES /* load bitcodes to r15 */
         add   r15, r15, r4 /* add number as byte offset */
         ldb   r2, (r15) /* load 7-seg value */
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
        addi  r16,r16,HEX_OFF /* turn off byte 1 */
        slli  r16,r16,8 /* logical shift left, 8-bits */
        or    r16,r16,r4 /* move r4 to byte 0 */
        stwio r16,0(r17) /*store value to HEX3210  */
        ret /* exit subroutine */
/*
   DISPLAY_7654 subroutine
   This will blank HEX7654 displays by writing
   0xFFFFFFFF
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
