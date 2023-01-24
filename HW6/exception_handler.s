        .include "address_map.s"

/********************************************************************************
* RESET SECTION
* The Monitor Program automatically places the ".reset" section at the reset location
* specified in the CPU settings in Qsys.
* Note: "ax" is REQUIRED to designate the section as allocatable and executable.
*/
.section .reset, "ax"
LOAD_START_LABEL:
        movia r2, _start /* move address of start label */
        jmp r2 /* branch to main program */

/********************************************************************************
* EXCEPTIONS SECTION
* The Monitor Program automatically places the ".exceptions" section at the
* exception location specified in the CPU settings in Qsys.
* Note: "ax" is REQUIRED to designate the section as allocatable and executable.
*/
.section .exceptions, "ax"
.global EXCEPTION_HANDLER

EXCEPTION_HANDLER:
        subi  sp,sp,16 /* Move stack pointer 4 bytes */
        stwio et,0(sp) /* Move exception temporary to stack */ 
        rdctl et,ctl4 /* Determine pending interrupt */
        beq   et,r0,SKIP_EA_DEC /* Interrupt is not external */
        subi  ea,ea,4 /* Must decrement ea by one instruction  for external interrupts,
                          so that interrupted instruction will be run after eret */
SKIP_EA_DEC:
        stwio ea,4(sp) /* Save exception return address */
        stwio ra,8(sp) /* Save return address */
        stwio r22,12(sp) /* Save contents of r22 */
        rdctl et,ctl4 /* Read pending interrupts */
        bne   et,r0, CHECK_IRQ_1 /* exception is an external interrupt */
NOT_EXTERNAL_INTERRUPT: /* exception must be unimplemented instruction or TRAP */
        br    END_ISR /* instruction. This code does not handle those cases */

CHECK_IRQ_1: /* pushbutton KEYS port is interrupt level 1 */
        andi  r22,et,0b10 /* Mask exception temporary with KEYS IRQ */ 
        beq   r22,r0,END_ISR /* other interrupt levels are not handled in this code */
        call  PUSHBUTTON_ISR /* Call PUSHBUTTON_ISR */
END_ISR:
        ldwio et, 0(sp) /* reload exception temporary address */
        ldwio ea, 4(sp) /* reload exception return address */
        ldwio ra, 8(sp) /* reload return address */
        ldwio r22, 12(sp) /* reload contents of r22 */
        addi  sp, sp, 16 /* add 4 bytes to stack pointer */

        eret  /* Return from Exception Handler */
.end
