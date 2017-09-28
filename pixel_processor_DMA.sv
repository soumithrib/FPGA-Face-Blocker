//Modified version of nios_system_Video_DMA. Modified by Soumithri Bala and
//Peter Kuimelis.

module pixel_processor_DMA (input clk,
                            input reset,
                            input [15:0]stream_data,
                            input stream_startofpacket,
                            input stream_endofpacket,
                            input [0:0]stream_empty,
                            input stream_valid,
                            input master_waitrequest,
                            input [1:0]slave_address,
                            input [3:0]slave_byteenable,
                            input slave_read,
                            input slave_write,
                            input [31:0]slave_writedata,
									 input [1:0]key_n,
									 input [17:0]s,
                           output stream_ready,
                           output [31:0]master_address,
                           output master_write,
                           output [15:0]master_writedata,
                           output [31:0]slave_readdata);

wire inc_address;
wire reset_address;

wire [31:0]buffer_start_address;
wire dma_enabled;

logic [8:0]w_address;
logic [7:0]h_address;
logic clear;
logic calibrate;

assign clear = ~key_n[0];
assign calibrate = ~key_n[1];

always_ff @(posedge clk)
begin
    if (reset)
    begin
        w_address <= 'h0;
        h_address <= 'h0;
    end
    else if (reset_address)
    begin
        w_address <= 'h0;
        h_address <= 'h0;
    end
    else if (inc_address)
    begin
        if (w_address == 319)
        begin
            w_address <= 'h0;
            h_address <= h_address + 1;
        end
        else
            w_address <= w_address + 1;
    end
end

assign master_address = buffer_start_address + {h_address, w_address, 1'b0};

video_dma_control_slave DMA_Control_Slave (.clk(clk),
                                           .reset(reset),
                                           .address(slave_address),
                                           .byteenable(slave_byteenable),
                                           .read(slave_read),
                                           .write(slave_write),
                                           .writedata(slave_writedata),
                                           .swap_addresses_enable(reset_address),
                                           .readdata(slave_readdata),
                                           .current_start_address(buffer_start_address),
                                           .dma_enabled(dma_enabled));

video_dma_to_memory From_Stream_to_Memory (.clk(clk),
                                           .reset(reset | ~dma_enabled),
														 .clear(clear),
														 .calibrate(calibrate),
														 .threshold(s[17:0]),
                                           .stream_data(stream_data),
                                           .stream_startofpacket(stream_startofpacket),
                                           .stream_endofpacket(stream_endofpacket),
                                           .stream_empty(stream_empty),
                                           .stream_valid(stream_valid),
                                           .master_waitrequest(master_waitrequest),
                                           .stream_ready(stream_ready),
                                           .master_write(master_write),
                                           .master_writedata(master_writedata),
                                           .inc_address(inc_address),
                                           .reset_address(reset_address));

endmodule
