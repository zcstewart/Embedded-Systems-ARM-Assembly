// Zachary Stewart
// ECE 178
// Created 2/27/2018

// Implements the nios_system created in Qsys
// For homework4

module homework4(CLOCK_50,KEY,SW,LEDG,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,
                 SRAM_DQ,SRAM_ADDR,SRAM_LB_N,SRAM_UB_N,SRAM_CE_N,SRAM_OE_N,SRAM_WE_N);
	input CLOCK_50;
	input [3:0] KEY;
	input [7:0] SW;
	inout [15:0] SRAM_DQ;
	output [19:0] SRAM_ADDR;
	output [17:0] LEDR;
	output [7:0] LEDG;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output SRAM_LB_N;
	output SRAM_UB_N;
	output SRAM_CE_N;
	output SRAM_OE_N;
	output SRAM_WE_N;
	
	nios_system NiosII (.clk_clk(CLOCK_50),
							  .keys_export(KEY[3:1]),
							  .leds_green_export(LEDR[17:0]),
							  .leds_red_export(LEDG[7:0]),
							  .switches_export(SW[7:0]),
							  .sram_DQ(SRAM_DQ[15:0]),
							  .sram_ADDR(SRAM_ADDR[19:0]),
							  .sram_LB_N(SRAM_LB_N),
							  .sram_UB_N(SRAM_UB_N),
							  .sram_CE_N(SRAM_CE_N),
							  .sram_OE_N(SRAM_OE_N),
							  .sram_WE_N(SRAM_WE_N),
							  .hex0_export(HEX0[6:0]),
							  .hex1_export(HEX1[6:0]),
							  .hex2_export(HEX2[6:0]),
							  .hex3_export(HEX3[6:0]),
							  .hex4_export(HEX4[6:0]),
							  .hex5_export(HEX5[6:0]));						  
endmodule