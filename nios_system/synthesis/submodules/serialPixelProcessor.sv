//Module to process pixels. Written by Peter Kuimelis.

module serialPixelProcessor(input clk,
									 input reset,
									 input ready,
									 input valid,
									 input pp_enable,
									 input c_enable,
									 input error,
									 input reset_addr,
									 input [8:0]threshold,
									 input [15:0]inPixel,
									 input [15:0]skinPixel,
									 input [8:0]pixelCountThreshold,
						   output logic [15:0]outPixel);

comparePixels CP000(.inPixel(inPixel), 
						  .valid(valid),
						  .threshold(threshold),
						  .skinPixel(skinPixel),
						  .detected(detected));
	
integer i;
integer row_count = 0;
integer col_count = 0;
integer rowMajorSquareIdx;
integer counter = 0;
integer pixelCounter [191:0];		      // store number of skin tone pixels in each square 
logic squareStatus [191:0];				  // store state of region (1 = blur, 0 = pass through) 
wire detected;
	
initial												  // initialize registers
begin
	for (i = 0; i < 192; i=i+1)
	begin
		squareStatus[i] <= 1'b0;
		pixelCounter[i] <= 0;
	end
end

always_ff @(posedge clk)
begin 
	if (reset)
	begin
		counter <= 0;
		col_count <= 0;
		row_count <=0;
		for (i = 0; i < 192; i=i+1)
		begin
			squareStatus[i] <= 1'b0;
			pixelCounter[i] <= 0;
		end
	end
	else if (ready)
	begin
		if (counter == 76800 - 1)
		begin
			counter <= 0;
			for (i = 0; i < 192; i=i+1)
			begin
//				if (((i - 17) >= 0) && ((i + 17) < 192))
//				begin
//					if (squareStatus[i]) 
//					begin
//						squareStatus[i+1] <= 1;
//						squareStatus[i-16] <= 1;
//						squareStatus[i-16-1] <= 1;
//						squareStatus[i-16+1] <= 1;
//						squareStatus[i+16+1] <= 1;
//						squareStatus[i+16-1] <= 1;
//						squareStatus[i+16] <= 1;
//					end
//				end
				if (pixelCounter[i]	> pixelCountThreshold)
					squareStatus[i] <= 1;
				else
					squareStatus[i] <= 0;
				pixelCounter[i] <= 0;
			end
		end
		else
			counter <=counter+1;

		if (counter % 20 == 0)
			col_count <= col_count + 1;
		if (counter % 6400 == 0)
			row_count <= row_count + 1;
		if (col_count == 16)
			col_count <=0;	
		if (row_count == 12)
			row_count <=0;
	end
		
	else if (reset_addr)
	begin
		counter <= 0;
		col_count <=0;
		row_count <=0;
	end
	else
	begin
		for (i = 0; i<192; i=i+1)
		begin
			if (((i - 17) >= 0) && ((i + 17) < 192))
			begin
				/*if (squareStatus[i-1] && 
					squareStatus[i+1] &&
					squareStatus[i-16] &&
					squareStatus[i-16-1] &&
					squareStatus[i-16+1] &&
					squareStatus[i+16+1] &&
					squareStatus[i+16-1] &&
					squareStatus[i+16])
					
					squareStatus[i] <=1;
					
				if (~squareStatus[i-1] && 
					~squareStatus[i+1] &&
					~squareStatus[i-16] &&
					~squareStatus[i-16-1] &&
					~squareStatus[i-16+1] &&
					~squareStatus[i+16+1] &&
					~squareStatus[i+16-1] &&
					~squareStatus[i+16])
					
					squareStatus[i] <=0;*/
					
				
			end
		end
	end
	
	if (detected)															
		pixelCounter[rowMajorSquareIdx]<=pixelCounter[rowMajorSquareIdx]+1;
end
	
always_comb
	rowMajorSquareIdx <= row_count * 16 + col_count;		// get block address
	
always_comb																// MUX pixel output
begin
	case ({pp_enable, c_enable, error})
		3'b100 :
		begin
			case ((squareStatus[rowMajorSquareIdx]+
					squareStatus[rowMajorSquareIdx-1]+
					squareStatus[rowMajorSquareIdx+1]+
					squareStatus[rowMajorSquareIdx+16]+
					squareStatus[rowMajorSquareIdx+16-1]+
					squareStatus[rowMajorSquareIdx+16+1]+
					squareStatus[rowMajorSquareIdx-16]+
					squareStatus[rowMajorSquareIdx-16-1]+
					squareStatus[rowMajorSquareIdx-16+1]) > 0)
			1'b1:
				outPixel = skinPixel;
			default:
				outPixel = inPixel;
			endcase
		end
		3'b010 :
		begin
			case (rowMajorSquareIdx)
			104:
				outPixel = skinPixel;
			103:
				outPixel = 16'b0000011111100000;
			105:
				outPixel = 16'b0000011111100000;
			87:
				outPixel = 16'b0000011111100000;
			88:
				outPixel = 16'b0000011111100000;
			89:
				outPixel = 16'b0000011111100000;
			119:
				outPixel = 16'b0000011111100000;
			120:
				outPixel = 16'b0000011111100000;
			121:
				outPixel = 16'b0000011111100000;
			default:
				outPixel = inPixel;
			endcase
		end
		3'b001 :
		begin
			case (rowMajorSquareIdx)
			104:
				outPixel = 16'b1111100000000000;
			87:
				outPixel = 16'b1111100000000000;
			89:
				outPixel = 16'b1111100000000000;
			121:
				outPixel = 16'b1111100000000000;
			119:
				outPixel = 16'b1111100000000000;
			default:
				outPixel = inPixel;
			endcase
		end
		default :
			outPixel = inPixel;
	endcase
end
endmodule