/* Nios Components */
        .equ TIMER_RHY,   0x00202020
        .equ TIMER_HAR,   0x00202000
        .equ GPIO_RHY,    0x002020b0
        .equ GPIO_HAR,    0x00202090
        .equ KEYS,        0x002020a0
        .equ HEX3210,     0x00202050
        .equ HEX7654,     0x00202040
        .equ LCD,         0x00201000
/* Register Offsets */
        .equ TIMER_STATUS,     0  /* Timer Status Register */
        .equ TIMER_CONTROL,    4  /* Timer Control Register */
        .equ TIMER_PERIODL,    8  /* Timer Period Low Register */
        .equ TIMER_PERIODH,    12 /* Timer Period High Register */
        .equ TIMER_SNAPL,      16 /* Timer Snapshot Low Register */
        .equ TIMER_SNAPH,      20 /* Timer Snapshot High Register */
        .equ GPIO_DATA,        0  /* GPIO Data Register*/
        .equ GPIO_DIRECTION,   4  /* GPIO Data Direction Register */
        .equ KEYS_DATA,        0  /* KEYS Data Register */
        .equ KEYS_DIRECTION,   4  /* KEYS Data Direction Register */
        .equ KEYS_INTMASK,     8  /* KEYS Interrupt Mask Register */
        .equ KEYS_EDGECAPTURE, 12 /* KEYS Edge-Capture Register */
        .equ STACK_BASE,       0x001FFFFF /* Base address for stack */
        .equ LCD_DATA,         1
        .equ LCD_INSTRUCTION,  0
/* HEX7654 HEX3210 values */
        .equ SEG7_A, 0b0001000 /* 7-Seg value for A */
        .equ SEG7_b, 0b0000011 /* 7-Seg value for b */
        .equ SEG7_C, 0b1000110 /* 7-Seg value for C */
        .equ SEG7_d, 0b0100001 /* 7-Seg value for d */
        .equ SEG7_E, 0b0000110 /* 7-Seg value for E */
        .equ SEG7_F, 0b0001110 /* 7-Seg value for F */
        .equ SEG7_g, 0b0010000 /* 7-Seg value for g */
        .equ SEG7_G_sharp, 0b1000010 /* 7-Seg value for Gsharp */
        
        .equ DELAY_50us,   0x9C4
        .equ DELAY_150us,  0x1D4C



/*                  b7 b6-0
SETCURSORLOCATION   1  Address
SHIFTDISPLAYLEFT    0  0011000
SHIFTDISPLAYRIGHT   0  0011100
CURSOROFF           0  0001100
CURSORBLINKON       0  0001111
CLEARDISPLAY        0  0000001
*/
