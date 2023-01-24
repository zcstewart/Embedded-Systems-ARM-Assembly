/* 
   Zachary Stewart
   ECE 178 Embedded Systems Design
   Homework 4 Part 1
*/
        .text
        .equ SWITCHES, 0x2020d0 /* Address of switches */
        .equ LEDR,     0x2020a0 /* Address of Red LEDs */
        .equ LEDG,     0x2020b0 /* Address of Green LEDs */


        .global _start /* Beginning of program */

_start:

        movia   r6,SWITCHES /* Load address of SWITCHES */
        movia   r7,LEDG /* Load address of Green LEDs */
        movia   r8,LEDR /* Load address of Red LEDs */
        movi    r2,0 /* Initialize accumulator to 0 */
LOOP:   ldwio   r3,0(r6) /* Load contents of switches */
        stwio   r3,0(r8) /* Store value to Green LEDs */
        add     r2,r2,r3 /* Add value to accumulator */
        stwio   r2,0(r7) /* Store sum to red LEDs */
WAIT:   ldwio   r4,0(r6) /* Check for new switch input */
        beq     r4,r3,WAIT /* If no new input, wait for new input */
        br      LOOP /* If new input, loop to top */

        .end        /* End of program */
