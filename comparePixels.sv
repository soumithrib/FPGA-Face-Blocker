//Module to compare pixels. Written by Peter Kuimelis.

module comparePixels(input [15:0] inPixel,
							input [15:0] skinPixel,
							input valid,
							input [8:0]threshold,
							output logic detected);					
	
integer val;
	
integer inR = 0;
integer inG = 0;
//integer inB = 0;
	
integer skR = 0;
integer skG = 0;
//integer skB = 0;
	
always_comb
begin
		inR = inPixel[15:11];
		inG = inPixel[10:5];
		//inB = inPixel[4:0];
			
		skR = skinPixel[15:11];
		skG = skinPixel[10:5];
		//skB = skinPixel[4:0];
		
		val =((inR - skR) * (inR - skR) +
				(inG - skG) * (inG - skG) /*+
				(inB - skB) * (inB - skB)*/);
					
		if ((val < threshold) && valid)
			detected = 1'b1;
		else
			detected = 1'b0;
end

endmodule
	