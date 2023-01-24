/* Zachary Stewart
   ECE 178 Embedded Systems
   Homework1

   Equates array with address 0x500 */
.equ	Array, 0x500

/* Program begins execution at _start label */
.global	_start

/*
movia:	  move immediate address into word. I-Type Instruction Is actually two 
		  instructions: orhi rB, r0, %hiadj(label) and addi rB, rB, %lo(label)

ldw:	  load 32-bit word from memory or I/O Peripheral. I-Type Instruction.
		  Computes the effective byte address specified by the sum of rA and 
		  the instructions signed 16-bit immediate value. Loads register rB 
		  with the memory word located at the effective byte address. The 
		  effective byte address must be word aligned. If the byte address is 
		  not a multiple of 4, the operation is undefined.
		  ldw rB, byte_offset(rA)

addi:	  Sign-extends the 16-bit immediate value and adds it to the value of 
		  rA. Stores the sum in rB.
		  addi rB, rA, IMM16

subi:	  Sign-extends the immediate value IMMED to 32 bits, subtracts it from the 
		  value of rA, then stores the result in rB.

beq		  If rA == rB, then beq transfers program control to the instruction at label. 
		  In the instruction encoding, the offset given by IMM16 is treated as a 
		  signed number of bytes relative to the  instruction immediately following beq.
		  The two least-significant  bits of IMM16 are always zero, because instruction
		  addresses must  be word-aligned.

bge		  If (signed) rA >= (signed) rB, then bge transfers program control to the 
		  instruction at label. In the instruction encoding, the offset given by IMM16 
		  is treated as a signed number of bytes relative to the instruction 
		  immediately following bge. The two least-significant bits of IMM16 are 
		  always zero, because instruction addresses must be word-aligned.

add		  Calculates the sum of rA and rB. Stores the result in rC. Used for both 
		  signed and unsigned addition.

br		  Transfers program control to the instruction at label. In the instruction 
		  encoding, the offset given by IMM16 is treated as a signed number of bytes 
		  relative to the instruction immediately following br. The two 
		  least-significant bits of IMM16 are always zero, because instruction 
		  addresses must be wordaligned.

stw		  Computes the effective byte address specified by thesum of rA and the 
		  instruction's signed 16-bit immediate value. Stores rB to the memory 
		  location specified by the effective byte address. The effective byte address 
		  must be word aligned. If the byte address is not a multiple of 4, the 
		  operation is undefined.
*/
_start:
		movia	r4,Array	/* LOAD ARRAY ADDRESS move immed addr of Array to r4 */
		ldw		r5,4(r4)	/* LOAD COUNTER VARIABLE (one byte above 0x500)  */
		addi	r6,r4,8		/* Add two bytes to address in r4, then store in r6 */
							/* sign-extends 8 to 16-bit, adds to r4, stores in r6 */
		ldw		r7,(r6)		/* no byte offset, loads r7 with word in r6 */
LOOP:
		subi	r5,r5,1		/* DECREMENT COUNTERsign-extends 1 to 32 bits, subtracts 
							   from r5, stores in r5 */
		beq		r5,r0,DONE	/* if r5 == zero, branch to instruction in DONE label */
		addi	r6,r6,4		/* Incremement address by byte to get next Array element 
							   sign-extends 4 to 16 bits, adds to r6, stores in r6 */
		ldw		r8,(r6)		/* no byte offset, load array element from r6 to r8 */
		bge		r7,r8,LOOP	/* if r7 >= r8, branch to instruction in LOOP label */
		add		r7,r8,r0	/* add zero to r8, store in r7 */
		br		LOOP		/* branch to instruction in LOOP label */
DONE:
		stw		r7,(r4)		/* Store MAXIMUM ARRAY VALUE from r7 to r4 (0x500) */
STOP:
		br		STOP		/* branch to instruction in STOP label (infinite loop) */

/* Tells assembler where to load instructions and data in memory */
.org	0x500
/* Allocates space, tells compiler to skip a byte (0x4 in memory) */
RESULT:
.skip	4
/* Creates a 7 in memory the size of a word (COUNTER VARIABLE for array length)*/
Count:
.word	7
/* Creates an "array" of seven words in memory */
NUMBERS:
.word 7,0,2,5,6,9,1
/* End of program */
.end
