//Modified version of nios_system_Video_DMA. Modified by Soumithri Bala and
//Peter Kuimelis.

module video_dma_control_slave (input clk,
                                input reset,
                                input [1:0]address,
                                input [3:0]byteenable,
                                input read,
                                input write,
                                input [31:0]writedata,
                                input swap_addresses_enable,
                         output logic [31:0]readdata,
                               output [31:0]current_start_address,
                         output logic dma_enabled);

logic [31:0]buffer_start_address;
logic [31:0]back_buf_start_address;
logic buffer_swap;

always @(posedge clk)
begin
    if (reset)
        readdata <= 32'h00000000;

    else if (read & (address == 2'h0))
        readdata <= buffer_start_address;

    else if (read & (address == 2'h1))
        readdata <= back_buf_start_address;

    else if (read & (address == 2'h2))
    begin
        readdata[31:16] <= 480;
        readdata[15:0]  <= 640;
    end

    else if (read)
    begin
        readdata[31:16] <= 16'h0809;
        readdata[15:12] <= 4'h0;
        readdata[11:8]  <= 4'h7;
        readdata[7:6]   <= 2'h2;
        readdata[5:3]   <= 3'h0;
        readdata[2]     <= dma_enabled;
        readdata[1]     <= 1'b1;
        readdata[0]     <= buffer_swap;
    end
end

always @(posedge clk)
begin
    if (reset)
    begin
        buffer_start_address <= 32'h00000000;
        back_buf_start_address <= 32'h00000000;
    end
    else if (write & (address == 2'h1))
    begin
        if (byteenable[0])
            back_buf_start_address[7:0]   <= writedata[7:0];
        if (byteenable[1])
            back_buf_start_address[15:8]  <= writedata[15:8];
        if (byteenable[2])
            back_buf_start_address[23:16] <= writedata[23:16];
        if (byteenable[3])
            back_buf_start_address[31:24] <= writedata[31:24];
    end
    else if (buffer_swap & swap_addresses_enable)
    begin
        buffer_start_address <= back_buf_start_address;
        back_buf_start_address <= buffer_start_address;
    end
end

always @(posedge clk)
begin
    if (reset)
        buffer_swap <= 1'b0;
    else if (write & (address == 2'h0))
        buffer_swap <= 1'b1;
    else if (swap_addresses_enable)
        buffer_swap <= 1'b0;
end

always @(posedge clk)
begin
    if (reset)
        dma_enabled <= 1'b1;
    else if (write & (address == 2'h3) & byteenable[0])
        dma_enabled <= writedata[2];
end

assign current_start_address = buffer_start_address;

endmodule
