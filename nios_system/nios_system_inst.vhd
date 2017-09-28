	component nios_system is
		port (
			I2C_SDAT_to_and_from_the_AV_Config              : inout std_logic                     := 'X';             -- SDAT
			I2C_SCLK_from_the_AV_Config                     : out   std_logic;                                        -- SCLK
			SRAM_DQ_to_and_from_the_Pixel_Buffer            : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			SRAM_ADDR_from_the_Pixel_Buffer                 : out   std_logic_vector(19 downto 0);                    -- ADDR
			SRAM_LB_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- LB_N
			SRAM_UB_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- UB_N
			SRAM_CE_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- CE_N
			SRAM_OE_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- OE_N
			SRAM_WE_N_from_the_Pixel_Buffer                 : out   std_logic;                                        -- WE_N
			VGA_CLK_from_the_VGA_Controller                 : out   std_logic;                                        -- CLK
			VGA_HS_from_the_VGA_Controller                  : out   std_logic;                                        -- HS
			VGA_VS_from_the_VGA_Controller                  : out   std_logic;                                        -- VS
			VGA_BLANK_from_the_VGA_Controller               : out   std_logic;                                        -- BLANK
			VGA_SYNC_from_the_VGA_Controller                : out   std_logic;                                        -- SYNC
			VGA_R_from_the_VGA_Controller                   : out   std_logic_vector(7 downto 0);                     -- R
			VGA_G_from_the_VGA_Controller                   : out   std_logic_vector(7 downto 0);                     -- G
			VGA_B_from_the_VGA_Controller                   : out   std_logic_vector(7 downto 0);                     -- B
			TD_CLK27_to_the_Video_In_Decoder                : in    std_logic                     := 'X';             -- TD_CLK27
			TD_DATA_to_the_Video_In_Decoder                 : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- TD_DATA
			TD_HS_to_the_Video_In_Decoder                   : in    std_logic                     := 'X';             -- TD_HS
			TD_VS_to_the_Video_In_Decoder                   : in    std_logic                     := 'X';             -- TD_VS
			Video_In_Decoder_external_interface_clk27_reset : in    std_logic                     := 'X';             -- clk27_reset
			TD_RESET_from_the_Video_In_Decoder              : out   std_logic;                                        -- TD_RESET
			overflow_flag_from_the_Video_In_Decoder         : out   std_logic;                                        -- overflow_flag
			clk_clk                                         : in    std_logic                     := 'X';             -- clk
			pixel_processor_dma_key_n                       : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- key_n
			reset_reset_n                                   : in    std_logic                     := 'X'              -- reset_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			I2C_SDAT_to_and_from_the_AV_Config              => CONNECTED_TO_I2C_SDAT_to_and_from_the_AV_Config,              --        AV_Config_external_interface.SDAT
			I2C_SCLK_from_the_AV_Config                     => CONNECTED_TO_I2C_SCLK_from_the_AV_Config,                     --                                    .SCLK
			SRAM_DQ_to_and_from_the_Pixel_Buffer            => CONNECTED_TO_SRAM_DQ_to_and_from_the_Pixel_Buffer,            --     Pixel_Buffer_external_interface.DQ
			SRAM_ADDR_from_the_Pixel_Buffer                 => CONNECTED_TO_SRAM_ADDR_from_the_Pixel_Buffer,                 --                                    .ADDR
			SRAM_LB_N_from_the_Pixel_Buffer                 => CONNECTED_TO_SRAM_LB_N_from_the_Pixel_Buffer,                 --                                    .LB_N
			SRAM_UB_N_from_the_Pixel_Buffer                 => CONNECTED_TO_SRAM_UB_N_from_the_Pixel_Buffer,                 --                                    .UB_N
			SRAM_CE_N_from_the_Pixel_Buffer                 => CONNECTED_TO_SRAM_CE_N_from_the_Pixel_Buffer,                 --                                    .CE_N
			SRAM_OE_N_from_the_Pixel_Buffer                 => CONNECTED_TO_SRAM_OE_N_from_the_Pixel_Buffer,                 --                                    .OE_N
			SRAM_WE_N_from_the_Pixel_Buffer                 => CONNECTED_TO_SRAM_WE_N_from_the_Pixel_Buffer,                 --                                    .WE_N
			VGA_CLK_from_the_VGA_Controller                 => CONNECTED_TO_VGA_CLK_from_the_VGA_Controller,                 --   VGA_Controller_external_interface.CLK
			VGA_HS_from_the_VGA_Controller                  => CONNECTED_TO_VGA_HS_from_the_VGA_Controller,                  --                                    .HS
			VGA_VS_from_the_VGA_Controller                  => CONNECTED_TO_VGA_VS_from_the_VGA_Controller,                  --                                    .VS
			VGA_BLANK_from_the_VGA_Controller               => CONNECTED_TO_VGA_BLANK_from_the_VGA_Controller,               --                                    .BLANK
			VGA_SYNC_from_the_VGA_Controller                => CONNECTED_TO_VGA_SYNC_from_the_VGA_Controller,                --                                    .SYNC
			VGA_R_from_the_VGA_Controller                   => CONNECTED_TO_VGA_R_from_the_VGA_Controller,                   --                                    .R
			VGA_G_from_the_VGA_Controller                   => CONNECTED_TO_VGA_G_from_the_VGA_Controller,                   --                                    .G
			VGA_B_from_the_VGA_Controller                   => CONNECTED_TO_VGA_B_from_the_VGA_Controller,                   --                                    .B
			TD_CLK27_to_the_Video_In_Decoder                => CONNECTED_TO_TD_CLK27_to_the_Video_In_Decoder,                -- Video_In_Decoder_external_interface.TD_CLK27
			TD_DATA_to_the_Video_In_Decoder                 => CONNECTED_TO_TD_DATA_to_the_Video_In_Decoder,                 --                                    .TD_DATA
			TD_HS_to_the_Video_In_Decoder                   => CONNECTED_TO_TD_HS_to_the_Video_In_Decoder,                   --                                    .TD_HS
			TD_VS_to_the_Video_In_Decoder                   => CONNECTED_TO_TD_VS_to_the_Video_In_Decoder,                   --                                    .TD_VS
			Video_In_Decoder_external_interface_clk27_reset => CONNECTED_TO_Video_In_Decoder_external_interface_clk27_reset, --                                    .clk27_reset
			TD_RESET_from_the_Video_In_Decoder              => CONNECTED_TO_TD_RESET_from_the_Video_In_Decoder,              --                                    .TD_RESET
			overflow_flag_from_the_Video_In_Decoder         => CONNECTED_TO_overflow_flag_from_the_Video_In_Decoder,         --                                    .overflow_flag
			clk_clk                                         => CONNECTED_TO_clk_clk,                                         --                                 clk.clk
			pixel_processor_dma_key_n                       => CONNECTED_TO_pixel_processor_dma_key_n,                       --                 pixel_processor_dma.key_n
			reset_reset_n                                   => CONNECTED_TO_reset_reset_n                                    --                               reset.reset_n
		);

