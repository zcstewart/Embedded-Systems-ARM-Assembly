/*
	Zachary Stewart
    homework8
*/

        .text
        .include "address_map.s"        

        .global _start /* beginning of program */  
_start:

VARIABLE_DECLARATION:
        movi   r9,0b0 /* NOTES offset variable */
        movi   r6,0b0 /* On/Off variable */
        movi   r7,0x18 /* Terminating NOTES array value */
        movi   r8,0b0 /* GPIO variable */
        movia  r18,NOTES

        call   INITIALIZE_STACK /* Initialize Stack base address */
        call   ENABLE_NIOSII_INTERRUPTS /* Configure Interrupts */
        call   INITIALIZE_GPIO /* Configure JP5 GPIO */
        call   INITIALIZE_TIMER /* Configure TIMER */
        call   INITIALIZE_KEYS /* Configure KEYS */


LOOP:

        br     LOOP /* Branch to LOOP */





/************************************************************************/
/* SUBROUTINES                                                          */
/************************************************************************/
INITIALIZE_STACK:
        movia  sp,STACK_BASE /* Move address of stack pointer */
        ret /* Return from subroutine */

ENABLE_NIOSII_INTERRUPTS:
        /* ctl4 */
        movi   r11,0b0011 /* IRQ 0 1 */
        wrctl  ienable,r11 /* Enable IRQ 0 1 */
        /* ctl0 */
        movi   r11,0b0001 /* PIE bit enables external interrupts */
        wrctl  status,r11  /* Write 1 to PIE bit */
        ret /* Return from subroutine */

INITIALIZE_GPIO:
        movi  r2,0b1 /* One */
        movia r4,GPIO /* Load GPIO address */
        stwio r2,GPIO_DIRECTION(r4) /* Set to output */
        stwio r0,GPIO_DATA(r4) /* Write a 0 to GPIO */
        ret /* Return from subroutine */

INITIALIZE_TIMER:
        movia r4,TIMER /* TIMER_RHY address */
        movi  r2,0b1000 /* Stop bit */
        stwio r2,TIMER_CONTROL(r4) /* Stop TIMER_RHY */
        ldwio r3,(r18) /* Load PERIOD_RHY */
        sthio r3,TIMER_PERIODL(r4) /* Store halfword to PERIODL */
        srli  r3,r3,16 /* Logical shift right 16 bits */
        sthio r3,TIMER_PERIODH(r4) /* Store halfword to PERIODH */
        ret /* Return from subroutine */

INITIALIZE_KEYS:
        movia r4,KEYS
        movi  r2,0b0111
        stwio r2,KEYS_EDGECAPTURE(r4)
        stwio r2,KEYS_INTMASK(r4)
        ret /* Return from subroutine */

        .data

NOTES:
        .word 0x29919, 0x25076, 0x1BBE4, 0x14C8C, 0xF920, 0xC5BC, 0x9422

        .end
