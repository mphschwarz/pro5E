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
		AMPLITUDE <= power_int;
		FREQUENCY <= 2**12 - 1 - power_int;
		CW <= 0;
		CCW <= 1;
	end


endmodule
