//Initialization module. Written by Soumithri Bala.

module project_base (input	CLOCK_50,
									input	TD_CLK27,
									input	[3:0]	KEY,
									input	[7:0] TD_DATA,
									input	TD_HS,
									input	TD_VS,
							input logic [17:0]S,
									inout	[15:0] SRAM_DQ,
									inout	I2C_SDAT,
									output TD_RESET_N,
									output [19:0] SRAM_ADDR,
									output SRAM_CE_N,
									output SRAM_WE_N,
									output SRAM_OE_N,
									output SRAM_UB_N,
									output SRAM_LB_N,
									output VGA_CLK,
									output VGA_HS,
									output VGA_VS,
									output VGA_BLANK_N,
									output VGA_SYNC_N,
									output [7:0] VGA_R,
									output [7:0] VGA_G,
									output [7:0] VGA_B,
									output I2C_SCLK,
							      output [17:0]LEDR);

		assign TD_RESET_N	= 1'b1;
		assign LEDR = 18'b000000001000000001;

		nios_system nios_system (.clk_clk(CLOCK_50),
											.reset_reset_n(KEY[0]),
											.pixel_processor_dma_key_n(KEY[2:1]),
											.pixel_processor_dma_switch(S[17:0]),
											.I2C_SDAT_to_and_from_the_AV_Config(I2C_SDAT),
											.I2C_SCLK_from_the_AV_Config(I2C_SCLK),
											.SRAM_DQ_to_and_from_the_Pixel_Buffer(SRAM_DQ),
											.SRAM_ADDR_from_the_Pixel_Buffer(SRAM_ADDR),
											.SRAM_LB_N_from_the_Pixel_Buffer(SRAM_LB_N),
											.SRAM_UB_N_from_the_Pixel_Buffer(SRAM_UB_N),
											.SRAM_CE_N_from_the_Pixel_Buffer(SRAM_CE_N),
											.SRAM_OE_N_from_the_Pixel_Buffer(SRAM_OE_N),
											.SRAM_WE_N_from_the_Pixel_Buffer(SRAM_WE_N),
											.TD_CLK27_to_the_Video_In_Decoder(TD_CLK27),
											.TD_DATA_to_the_Video_In_Decoder(TD_DATA),
											.TD_HS_to_the_Video_In_Decoder(TD_HS),
											.TD_RESET_from_the_Video_In_Decoder(),
											.TD_VS_to_the_Video_In_Decoder(TD_VS),
											.VGA_CLK_from_the_VGA_Controller(VGA_CLK),
											.VGA_HS_from_the_VGA_Controller(VGA_HS),
											.VGA_VS_from_the_VGA_Controller(VGA_VS),
											.VGA_BLANK_from_the_VGA_Controller(VGA_BLANK_N),
											.VGA_SYNC_from_the_VGA_Controller(VGA_SYNC_N),
											.VGA_R_from_the_VGA_Controller(VGA_R),
											.VGA_G_from_the_VGA_Controller(VGA_G),
											.VGA_B_from_the_VGA_Controller(VGA_B));

endmodule
