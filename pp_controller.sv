//Pixel processor state machine. Written by Soumithri Bala.

module pp_controller (input clk,
                            reset,
                            clear,
                            calibrate,
                     output enable,
                            calibrateEnable,
									 error);

enum logic [1:0] {Initialize, Calibrate, Enabled, Reset} curr_state, next_state;

always_ff @ (posedge clk)
begin
    if (reset)
        curr_state <= Initialize;
    else
        curr_state <= next_state;
end

always_comb
begin
    next_state = curr_state;
    unique case (curr_state)
        Initialize:
            if (calibrate)
                next_state = Calibrate;
        Calibrate:
            if (~calibrate)
                next_state = Enabled;
        Enabled:
            if (clear)
                next_state = Reset;
		  Reset:
				if (~clear)
					 next_state = Initialize;
    endcase
end

always_comb
begin
    case (curr_state)
        Initialize:
        begin
            enable = 0;
            calibrateEnable = 0;
				error = 0;
        end
        Calibrate:
        begin
            enable = 0;
            calibrateEnable = 1;
				error = 0;
        end
        Enabled:
        begin
            enable = 1;
            calibrateEnable = 0;
				error = 0;
        end
		  Reset:
        begin
            enable = 0;
            calibrateEnable = 0;
				error = 1;
        end
		  default:
		  begin
				enable = 0;
				calibrateEnable = 0;
				error = 0;
			end
    endcase
end

endmodule
