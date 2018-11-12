module QUADRATUR_ENCODER_SIMPLE(
	input CLK,
	input A,
	input B,
	input RESET,
	output reg signed [31:0] COUNTER,
	output reg CW,
	output reg CCW
	);
	//
	initial
	begin	
		CW <= 0;
		CCW <= 0;
		COUNTER <= 0;
		//
	end
	//
	always @(posedge CLK)
	begin
	
	end
endmodule