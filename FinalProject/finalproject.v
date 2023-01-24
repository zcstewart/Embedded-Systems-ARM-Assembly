// Zachary Stewart
// ECE 178
// Created 3/24/2018

// Implements the nios_system created in Qsys
// For homework6

module finalproject(CLOCK_50,
                 KEY,GPIO,
					  SW,LEDR,LEDG,
					  HEX0,HEX1,HEX2,HEX3,
					  HEX4,HEX5,HEX6,HEX7,
					  SRAM_DQ,
					  SRAM_ADDR,
					  SRAM_LB_N,
					  SRAM_UB_N,
					  SRAM_CE_N,
					  SRAM_OE_N,
					  SRAM_WE_N);
					  
	input CLOCK_50;
	input  [3:0]  KEY;
	input  [17:0] SW;
	output [17:0] LEDR;
	output [7:0]  LEDG;
   output [6:0]  HEX0;
   output [6:0]  HEX1;
   output [6:0]  HEX2;
   output [6:0]  HEX3;
	output [6:0]  HEX4;
	output [6:0]  HEX5;
	output [6:0]  HEX6;
	output [6:0]  HEX7;
   output [31:0] GPIO;
	inout  [15:0] SRAM_DQ;
	output [19:0] SRAM_ADDR;
	output SRAM_LB_N;
	output SRAM_UB_N;
	output SRAM_CE_N;
	output SRAM_OE_N;
	output SRAM_WE_N;
	
	//Instantiate Nios System
	nios_music_system NiosII (.clk_clk(CLOCK_50),
							  .ledr_export(LEDR[17:0]),
							  .ledg_export(LEDG[7:0]),
							  .switches_export(SW[17:0]),
							  .reset_reset_n(KEY[0]),
							  .keys_export(KEY[3:1]),
							  .sram_DQ(SRAM_DQ[15:0]),
							  .sram_ADDR(SRAM_ADDR[19:0]),
							  .sram_LB_N(SRAM_LB_N),
							  .sram_UB_N(SRAM_UB_N),
							  .sram_CE_N(SRAM_CE_N),
							  .sram_OE_N(SRAM_OE_N),
							  .sram_WE_N(SRAM_WE_N),
							  .hex3210_export({1'b0,HEX3[6:0],1'b0,HEX2[6:0],1'b0,HEX1[6:0],1'b0,HEX0[6:0]}),
							  .hex7654_export({1'b0,HEX7[6:0],1'b0,HEX6[6:0],1'b0,HEX5[6:0],1'b0,HEX4[6:0]}),
							  .gpio_rhy_export(GPIO[2]),
							  .gpio_har_export(GPIO[3]));
	
endmodule
