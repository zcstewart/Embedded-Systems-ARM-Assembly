		.equ HEX3210,         0x08402030 /* Address of HEX0 */
        .equ HEX7654,         0x08402020 /* Address of HEX1 */
        .equ KEYS,            0x08402070 /* Address of KEYS */
        .equ SWITCHES,        0x08402060 /* Address of SWITCHES */
        .equ LEDR,            0x08402040 /* Address of LEDR */
        .equ LEDG,            0x08402050 /* Address of LEDG */
        .equ TIMER,           0x08402000 /* Address of Timer */
        .equ TIMER_STATUS,    0  /* Timer Status Register */
        .equ TIMER_CONTROL,   4  /* Timer Control Register */
        .equ TIMER_PERIODL,   8  /* Timer Period Low Register */
        .equ TIMER_PERIODH,   12 /* Timer Period High Register */
        .equ TIMER_SNAPL,     16 /* Timer Snapshot Low Register */
        .equ TIMER_SNAPH,     20 /* Timer Snapshot High Register */
        .equ KEYS_DATA,       0  /* KEYS Data Register */
        .equ KEYS_DIRECTION,  4  /* KEYS Data Direction Register */
        .equ KEYS_INTMASK,    8  /* KEYS Interrupt Mask Register */
        .equ KEYS_EDGECAPTURE,12 /* KEYS Edge-Capture Register */
        .equ STACK_BASE,      0x07FFFFFF /* Base address for stack */
        .equ HEX1,            0b11111001 /* 7-SEG code for 1 */
        .equ HEX2,            0b10100100 /* 7-SEG code for 2 */
        .equ HEX3,            0b10110000 /* 7-SEG code for 3 */
        .equ HEXOFF,          0b11111111 /* 7-SEG code for blank */
        .equ BLANK7SEG,       0xFFFFFFFF /* 32-bit value to clear 7-seg */
