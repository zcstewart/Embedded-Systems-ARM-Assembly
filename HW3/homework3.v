// Zachary Stewart
// ECE 178
// Created 2/8/2018

// Implements the nios_system created in Qsys
// For homework3

module homework3(CLOCK_50,KEY,LEDR,SRAM_DQ,SRAM_ADDR,SRAM_LB_N,SRAM_UB_N,SRAM_CE_N,SRAM_OE_N,SRAM_WE_N);
	input CLOCK_50;
	input [3:0] KEY;
	output [3:0] LEDR;
	inout [15:0] SRAM_DQ;
	output [19:0] SRAM_ADDR;
	output SRAM_LB_N;
	output SRAM_UB_N;
	output SRAM_CE_N;
	output SRAM_OE_N;
	output SRAM_WE_N;
	
	nios_system NiosII (.clk_clk(CLOCK_50),
							  .reset_reset_n(KEY[0]),
							  .leds_export(LEDR),
							  .buttons_export(KEY[3:1]),
							  .sram_DQ(SRAM_DQ),
							  .sram_ADDR(SRAM_ADDR),
							  .sram_LB_N(SRAM_LB_N),
							  .sram_UB_N(SRAM_UB_N),
							  .sram_CE_N(SRAM_CE_N),
							  .sram_OE_N(SRAM_OE_N),
							  .sram_WE_N(SRAM_WE_N));

endmodule
