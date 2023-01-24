/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 6 Part 1
*/
		.text

        .include "address_map.s"        

        .global _start /* beginning of program */  

_start:
      
CLEAR_7SEG:
        movia  r10,HEX7654 /* Load address of HEX7654 */
        nor    r11,r0,r0 /* set r11 to FFFFFFFF */
        stwio  r11,0(r10) /* turn off HEX7654 */
        movia  r10,HEX3210 /* Load address of HEX3210 */
        nor    r11,r0,r0 /* set r11 to FFFFFFFF */
        stwio  r11,0(r10) /* turn off HEX3210 */
INITIALIZE_STACK:
        movia  sp,STACK_BASE
INITIALIZE_KEY_COUNTERS:
        movi   r18,1 /* Counter to determine KEY1 status */
        movi   r19,1 /* Counter to determine KEY2 status */
        movi   r20,1 /* Counter to determine KEY3 status */
KEYS_INTERRUPT_MASK_REGISTER:
        movi   r15,0xF /* Value to clear Edgecapture */
        movia  r10,KEYS /* Load address of KEYS */
        stwio  r15,KEYS_EDGECAPTURE(r10) /* clear the edgecapture register */
        movi   r11,0b1111 /* KEY1, KEY2, and KEY3 */
        stwio  r11,KEYS_INTMASK(r10) /* Store value to enable KEY interrupts */
ENABLE_NIOSII_INTERRUPTS:
        /* ctl4 */
        movi   r11,0b0010 /* IRQ 1 for KEYS */
        wrctl  ienable,r11 /* Enable IRQ1 for KEYS */
        /* ctl0 */
        movi   r11,0b0001 /* PIE bit enables external interrupts */
        wrctl  status,r11  /* Write 1 to PIE bit */

IDLE:   br IDLE
		.end

