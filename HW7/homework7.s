/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 7 Part 1
*/

        .include "address_map.s"

		.text
        .global _start /* beginning of program */  

_start:      
        call  CONFIG_STACK
        call  INITIALIZE_COUNTER
        call  CONFIG_KEYS
        call  CONFIG_TIMER
        call  CONFIG_INTERRUPT

LOOP:
        br    LOOP /* Infinite Loop to wait for interrupts */

CONFIG_STACK:
        movia  sp,STACK_BASE /* Move STACK_BASE to stack pointer */
        ret /* return from subroutine */

INITIALIZE_COUNTER: /* These registers remain unchanged throughout program */
        mov   r17,r0 /* initialize milliseconds counter to zero */
        movi  r19,0x3E8 /* terminating milliseconds count value */
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

CONFIG_KEYS:
        movia  r3,KEYS
        movi   r2,0b111
        stwio  r2,KEYS_INTMASK(r3)
        stwio  r2,KEYS_EDGECAPTURE(r3)
        ret /* return from subroutine */

CONFIG_TIMER:
        /* Stop Timer */
        movia  r3,TIMER /* Load address of TIMER */
        movi   r2,0b1000 /* STOP bit */
        stwio  r2,TIMER_CONTROL(r3) /* Stop TIMER */
        movi   r2,0b0001 /* TO bit */
        stwio  r2,TIMER_STATUS(r3) /* Clear TO bit */
        movia  r3,TIMER_2sDELAY /* Load 2s delay address */
        ldwio  r2,(r3) /* Load 2s delay */
        sthio  r2,TIMER_PERIODL(r3) /* Store halfword to PERIODL */
        srli   r2,r2,16 /* Logical shift right 2 bytes */
        sthio  r2,TIMER_PERIODH(r3) /* Store halfword to PERIODH */
        ret /* return from subroutine */

CONFIG_INTERRUPT:
        /* ctl4 */
        movi  r2,0b0010 /* IRQ 0 for TIMER, IRQ 1 for KEYS */
        wrctl ienable,r2 /* Enable IRQ1 for KEYS */
        /* ctl0 */
        movi  r2,0b0001 /* PIE bit enables external interrupts */
        wrctl status,r2  /* Write 1 to PIE bit */
        ret /* return from subroutine */

           .data

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

           .global RAND_NUM
RAND_NUM:  
                .word 0x00000002 /* Random number memory location */

           .global TIMER_200msDELAY
TIMER_200msDELAY:
                .word 0x00989680 /* 200 ms delay */
           
           .global TIMER_1msDELAY
TIMER_1msDELAY: 
                .word 0x0000C350 /* 1 ms delay */
          
           .global TIMER_2sDELAY
TIMER_2sDELAY:  
                .word 0x05F5E100 /* 2 second delay */
           
           .global SEC1_DELAY
SEC1_DELAY:     
                .word 0x02FAF080 /* 1 SEC DELAY */

           .global SEC2_DELAY
SEC2_DELAY:     .word 0x05F5E100 /* 2 SEC DELAY */

           .global SEC3_DELAY
SEC3_DELAY:     .word 0x08F0D180 /* 3 SEC DELAY */

           .global SEC4_DELAY
SEC4_DELAY:     .word 0x0BEBC200 /* 4 SEC DELAY */

           .global SEC5_DELAY
SEC5_DELAY:     .word 0x0EE6B280 /* 5 SEC DELAY */

           .global SEC6_DELAY
SEC6_DELAY:     .word 0x11E1A300 /* 6 SEC DELAY */

           .global SEC7_DELAY
SEC7_DELAY:     .word 0x14DC9380 /* 7 SEC DELAY */

           .global SEC8_DELAY
SEC8_DELAY:     .word 0x17D78400 /* 8 SEC DELAY */

           .global SEC9_DELAY
SEC9_DELAY:     .word 0x1AD27480 /* 9 SEC DELAY */

           .global SEC10_DELAY
SEC10_DELAY:    .word 0x1DCD6500 /* 10 SEC DELAY */

           .global SEC11_DELAY
SEC11_DELAY:    .word 0x20C85580 /* 11 SEC DELAY */

           .global SEC12_DELAY
SEC12_DELAY:    .word 0x23C34600 /* 12 SEC DELAY */

           .global SEC13_DELAY
SEC13_DELAY:    .word 0x26BE3680 /* 13 SEC DELAY */

           .global SEC14_DELAY
SEC14_DELAY:    .word 0x29B92700 /* 14 SEC DELAY */

           .global SEC15_DELAY
SEC15_DELAY:    .word 0x2CB41780 /* 15 SEC DELAY */

		   .end
