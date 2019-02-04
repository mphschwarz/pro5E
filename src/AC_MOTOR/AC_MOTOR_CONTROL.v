module AC_MOTOR_CONTROL(
	input CLK,
	input [12:0] POWER,
	output reg CW,
	output reg CCW,
	output reg [12:0] FREQUENCY,
	output reg signed [12:0] AMPLITUDE
	);

	reg [12:0] power_int;

	initial begin
		power_int <= 2**10 - 1;
	end

	always @(posedge CLK) begin
		AMPLITUDE <= 2**12 - 1;
		FREQUENCY <= 2**12 - 1;
		CW <= 0;
		CCW <= 1;
	end
		//AMPLITUDE <= 2**12 - 1;
		//FREQUENCY <= 0;


endmodule
