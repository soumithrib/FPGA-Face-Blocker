//Module to get calibration pixel. Written by Peter Kuimelis and Soumithri Bala.

module calibration(input clk,
						 input reset,
					    input ready,
						 input c_enable,
						 input valid,
						 input reset_addr,
						 input [15:0]inPixel,
			   output logic [15:0]avgPixel);
											
logic [15:0] tempAvgPixel = 16'b1000001110001110;
int counter = 0;

always_ff @(posedge clk)
begin 
	if (ready)
	begin
		if (counter == 76800 - 1)
			counter <= 0;
		else
			counter <=counter+1;
	end
	else if (reset_addr)
	begin
		counter <= 0;
	end
	case (c_enable)
	1:
	begin
		if (counter == 38560 && valid)
			tempAvgPixel <= inPixel;
		
	end
	default:
		tempAvgPixel <= tempAvgPixel;
	endcase
end

assign avgPixel = tempAvgPixel;

endmodule

