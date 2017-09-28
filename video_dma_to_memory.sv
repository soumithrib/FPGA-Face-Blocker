//Modified version of nios_system_Video_DMA. Modified by Soumithri Bala and
//Peter Kuimelis.

module video_dma_to_memory (input clk,
                                  reset,
									 input clear,
									 input calibrate,
									 input [17:0]threshold,
                            input [15:0]stream_data,
                            input stream_startofpacket,
									       stream_endofpacket,
                            input [0:0]stream_empty,
                                  stream_valid,
                                  master_waitrequest,
                           output stream_ready,
                           output master_write,
                           output [15:0]master_writedata,
                           output inc_address,
                           output reset_address);
						
logic [15:0]temp_data;
logic temp_valid;
wire c_enable;
wire pp_enable;
wire [15:0]skinVal;
wire error;

parameter skinValsave = 16'b1000001110001110;

always_ff @(posedge clk)
begin
    if (reset)
    begin
        temp_data <= 'h0;
        temp_valid <= 1'b0;
    end
    else if (stream_ready)
    begin
        temp_data <= stream_data;
        temp_valid <= stream_valid;
    end
end

assign stream_ready = ~temp_valid | ~master_waitrequest;

assign master_write = temp_valid;
//assign master_writedata = 16'b1111100000000000;
//assign master_writedata = temp_data;

assign inc_address = stream_ready & stream_valid;
assign reset_address = inc_address & stream_startofpacket;

pp_controller controller(
	.clk(clk),
	.reset(reset),
	.clear(clear),
	.calibrate(calibrate),
	.enable(pp_enable),
	.error(error),
	.calibrateEnable(c_enable));
	
calibration calib(
	.clk(clk),
	.reset(reset),
	.ready(inc_address),
	.valid(temp_valid),
	.c_enable(c_enable),
	.reset_addr(reset_address),
	.inPixel(temp_data),
	.avgPixel(skinVal));

serialPixelProcessor SPP000(
	.clk(clk),
	.reset(reset),
	.threshold(threshold[17:9]),
	.valid(temp_valid),
	.pp_enable(pp_enable),
	.c_enable(c_enable),
	.error(error),
	.reset_addr(reset_address),
	.inPixel(temp_data),
	.skinPixel(skinVal),
	.pixelCountThreshold(threshold[8:0]),
	.outPixel(master_writedata),
	.ready(inc_address));

endmodule
