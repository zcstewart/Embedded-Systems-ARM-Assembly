module homework7
       (CLOCK_50,KEY,SW,LEDG,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,
                 SRAM_DQ,SRAM_ADDR,SRAM_LB_N,SRAM_UB_N,SRAM_CE_N,SRAM_OE_N,SRAM_WE_N,
					  DRAM_DQ,DRAM_ADDR,DRAM_DQM,DRAM_BA,DRAM_CAS_N,DRAM_CKE,DRAM_CLK,
					  DRAM_CS_N,DRAM_RAS_N,DRAM_WE_N);
					  
	input CLOCK_50;
	input  [3:0]  KEY;
	input  [17:0] SW;
	inout  [15:0] SRAM_DQ;
	inout  [31:0] DRAM_DQ;
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
	output [19:0] SRAM_ADDR;
	output [12:0] DRAM_ADDR;
	output [3:0] DRAM_DQM;
	output [1:0] DRAM_BA;
	output DRAM_CLK;
	output SRAM_LB_N;
	output SRAM_UB_N;
	output SRAM_CE_N;
	output SRAM_OE_N;
	output SRAM_WE_N;
	output DRAM_CAS_N;
	output DRAM_CKE;
	output DRAM_CS_N;
	output DRAM_RAS_N;
	output DRAM_WE_N;
	
	//Instantiate Nios System
	nios_system NiosII (.clk_clk(CLOCK_50),
							  .reset_reset_n(KEY[0]),
							  .keys_export(KEY[3:1]),
							  .ledr_export(LEDR[17:0]),
							  .ledg_export(LEDG[7:0]),
							  .switches_export(SW[17:0]),
							  .sram_DQ(SRAM_DQ[15:0]),
							  .sram_ADDR(SRAM_ADDR[19:0]),
							  .sram_LB_N(SRAM_LB_N),
							  .sram_UB_N(SRAM_UB_N),
							  .sram_CE_N(SRAM_CE_N),
							  .sram_OE_N(SRAM_OE_N),
							  .sram_WE_N(SRAM_WE_N),
							  .sdram_addr(DRAM_ADDR[12:0]),
							  .sdram_ba(DRAM_BA[1:0]),
							  .sdram_cas_n(DRAM_CAS_N),
							  .sdram_cke(DRAM_CKE),
							  .sdram_cs_n(DRAM_CS_N),
							  .sdram_dq(DRAM_DQ[31:0]),
							  .sdram_dqm(DRAM_DQM[3:0]),
							  .sdram_ras_n(DRAM_RAS_N),
							  .sdram_we_n(DRAM_WE_N),
							  .hex3210_export({1'b0,HEX3[6:0],1'b0,HEX2[6:0],1'b0,HEX1[6:0],1'b0,HEX0[6:0]}),
							  .hex7654_export({1'b0,HEX7[6:0],1'b0,HEX6[6:0],1'b0,HEX5[6:0],1'b0,HEX4[6:0]}));
	
   //Instantiate SDRAM PLL Controller	
	sdramPLL neg_3ns (.inclk0(CLOCK_50),.c0(DRAM_CLK));
			 
endmodule