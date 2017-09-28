module sram_read (input clk,
                        reset,
                        master_readdata[15:0],
                        master_readdatavalid,
                        master_waitrequest,
                        stream_ready,
                 output master_address[31:0],
                        master_arbiterlock,
                        master_read,
                        stream_data[15:0],
                        stream_startofpacket,
                        stream_endofpacket,
                        stream_empty,
                        stream_valid);

//Internal Connections

    logic   fifo_data_in[17:0];
    logic   fifo_read;
    logic   fifo_write;

    logic   fifo_data_out[31:0];
    logic   fifo_empty;
    logic   fifo_full;
    logic   fifo_almost_empty;
    logic   fifo_almost_full;

    logic   buffer_start_address[31:0];
    logic   back_buf_start_address[31:0];
    logic   buffer_swap;
    logic   pending_reads[3:0];
    logic   reading_first_pixel_in_image;
    logic   pixel_address[8:0];
    logic   line_address[7:0];

    logic   s_pixel_buffer[1:0];
    logic   ns_pixel_buffer[1:0];

//State Machine

    enum logic [1:0] {STATE_0_IDLE, STATE_1_WAIT_FOR_LAST_PIXEL, STATE_2_READ_BUFFER, STATE_3_MAX_PENDING_READS_STALL}

    always_ff @ (posedge clk)
    begin
        if (reset)
            s_pixel_buffer <= STATE_0_IDLE;
        else
            s_pixel_buffer <= ns_pixel_buffer;
    end

    always_comb
    begin
       case (s_pixel_buffer)
        STATE_0_IDLE:
            begin
                if (fifo_almost_empty)
                    ns_pixel_buffer = STATE_2_READ_BUFFER;
                else
                    ns_pixel_buffer = STATE_0_IDLE;
            end
        STATE_1_WAIT_FOR_LAST_PIXEL:
            begin
                if (pending_reads == 4'h0) 
                    ns_pixel_buffer = STATE_0_IDLE;
                else
                    ns_pixel_buffer = STATE_1_WAIT_FOR_LAST_PIXEL;
            end
        STATE_2_READ_BUFFER:
            begin
                if (~master_waitrequest)
                begin
                    if ((pixel_address == (PIXELS - 1)) & 
                        (line_address == (LINES - 1)))
                        ns_pixel_buffer = STATE_1_WAIT_FOR_LAST_PIXEL;
                    else if (fifo_almost_full) 
                        ns_pixel_buffer = STATE_0_IDLE;
                    else if (pending_reads >= 4'hC) 
                        ns_pixel_buffer = STATE_3_MAX_PENDING_READS_STALL;
                    else
                        ns_pixel_buffer = STATE_2_READ_BUFFER;
                end
                else
                    ns_pixel_buffer = STATE_2_READ_BUFFER;
            end
        STATE_3_MAX_PENDING_READS_STALL:
            begin
                if (pending_reads <= 4'h7) 
                    ns_pixel_buffer = STATE_2_READ_BUFFER;
                else
                    ns_pixel_buffer = STATE_3_MAX_PENDING_READS_STALL;
            end
        default:
            begin
                ns_pixel_buffer = STATE_0_IDLE;
            end
        endcase
    end

    always_ff @ (posedge clk)
    begin
        if (reset)
            pending_reads <= 4'h0;
        else if (master_read & ~master_waitrequest)
        begin
            if (~master_readdatavalid)
                pending_reads <= pending_reads + 1'h1;
        end
        else if (master_readdatavalid & (pending_reads != 4'h0))
            pending_reads <= pending_reads - 1'h1;
    end

    always_ff @ (posedge clk)
    begin
        if (reset)
            reading_first_pixel_in_image <= 1'b0;
        else if ((s_pixel_buffer == STATE_0_IDLE) &
                ((pixel_address == 0) & (line_address == 0)))
            reading_first_pixel_in_image <= 1'b1;
        else if (master_readdatavalid)
            reading_first_pixel_in_image <= 1'b0;
    end

    always_ff @ (posedge clk)
    begin
        if (reset)
            pixel_address <= 'h0;
        else if (master_read & ~master_waitrequest)
        begin
            if (pixel_address == (PIXELS - 1))
                pixel_address <= 'h0;
            else
                pixel_address <= pixel_address + 1;
        end
    end

    always_ff @ (posedge clk)
    begin
        if (reset)
            line_address <= 'h0;
        else if ((master_read & ~master_waitrequest) && 
                (pixel_address == (PIXELS - 1)))
        begin
            if (line_address == (LINES - 1))
                line_address <= 'h0;
            else
                line_address <= line_address + 1;
        end
    end

    scfifo Image_Buffer (
        // Inputs
        .clock			(clk),
        .sclr				(reset),

        .data				(fifo_data_in),
        .wrreq			(fifo_write),

        .rdreq			(fifo_read),

        // Outputs
        .q					(fifo_data_out),

        .empty			(fifo_empty),
        .full				(fifo_full),

        .almost_empty	(fifo_almost_empty),
        .almost_full	(fifo_almost_full)
        // synopsys translate_off
        ,

        .aclr				(),
        .usedw			()
        // synopsys translate_on);

    defparam
        Image_Buffer.add_ram_output_register	= "OFF",
        Image_Buffer.almost_empty_value			= 32,
        Image_Buffer.almost_full_value			= 96,
        Image_Buffer.intended_device_family		= "Cyclone II",
        Image_Buffer.lpm_numwords					= 128,
        Image_Buffer.lpm_showahead					= "ON",
        Image_Buffer.lpm_type						= "scfifo",
        Image_Buffer.lpm_width						= DW + 3,
        Image_Buffer.lpm_widthu						= 7,
        Image_Buffer.overflow_checking			= "OFF",
        Image_Buffer.underflow_checking			= "OFF",
        Image_Buffer.use_eab							= "ON";

endmodule
