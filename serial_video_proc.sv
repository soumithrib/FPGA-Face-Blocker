//Serial Video Processor. Written by Soumithri Bala and Peter Kuimelis.

module serial_video_proc(
	input reset;
	input [15:0] temp_pixel;
	input [15:0] skin_tone_pixel;
	input [15:0] pixel_count_threshold;
	output [15:0] final_pixel;
)

	pixel_compare pc000(.temp_pixel,.skin_tone_pixel,.skin_tone_detected);
	
	int i;
	int x, y, x_square, y_square, row_major_square_idx;
	int counter;
	wire skin_tone_detected;										// signal from skin tone comparison module
	reg [15:0] pixel_counter_reg [640/40 * 480/40];			// store number of skin tone pixels in each square as 16 x 12 16-bit counters
	reg region_status_reg [640/40 * 480/40];					// store state of region (1 = blur, 0 = pass through) as 16 x 12 flip-flops

	always_comb
	begin
		x = counter % 320;											// compute row major addresss of counter register from state counter
		y = counter / 320;
		x_square = x/320 * 16;
		y_square = y/240 * 12;
		row_major_square_idx = y_square * 16 + x_square;
	end
	always_ff
	begin 
		if (reset)														// reset case
			counter = 0;
			for (i = 0; i < 12 * 16; i = i + 1)
					region_status_reg[i] = 0;
		else
		begin
			if (counter == 320 * 240 - 1)							// EOF reached
			begin															// update pixel status registers
				for (i = 0; i < 12 * 16; i = i +1)
				begin
					if (pixel_counter_reg[i] > pixel_count_threshold)
						region_status_reg[i] = 1;
					else
						region_status_reg[i] = 0;
				end
				counter = 0;											// set state counter back to 0
			end
			else
			begin											
				if (skin_tone_detected)								// increment counter register of current square
				begin
					pixel_counter_reg[row_major_square_idx] = pixel_counter_reg[row_major_square_idx] + 1;			//inc.
				end
			end
			counter++;													// increment state counter
		end
	end
	always_comb
	begin 
		if (region_status_reg[row_major_square_idx])
			final_pixel = skin_tone_pixel;
		else
			final_pixel = temp_pixel;
		end
	end
endmodule

	
	
