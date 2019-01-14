module AC_MOTOR_TRIANGLE(
	input CLK,
	input CW_IN,
	input CCW_IN,
	input [level_bits - 1:0] AMPLITUDE,
	output reg CW_OUT,
	output reg CCW_OUT,
	output reg signed [bits + level_bits - 1:0] TRIANGLE);
	
	parameter starting_amplitude = 2;
	parameter levels = 16;
	parameter level_bits = 5;
	parameter bits = 12;
	
	// reg [log2(levels) - 1:0] amplitude_int;
	reg cw_int;
	reg ccw_int;
	reg signed [level_bits:0] amplitude_int;
	reg signed [level_bits:0] triangle_dir;
	reg signed [bits + level_bits:0] triangle_int;
	reg signed [bits + level_bits:0] triangle_max;
	reg signed [bits + level_bits:0] triangle_min;

	initial begin
		amplitude_int <= starting_amplitude;
		cw_int = 0;
		ccw_int = 1;
		triangle_dir <= starting_amplitude;
		triangle_int <= 0;
		triangle_max <= starting_amplitude * 2048;
		triangle_min <= -starting_amplitude * 2048;
	end

	always @(posedge CLK) begin
		// if (triangle_int >= triangle_max) begin
		// 	// triangle_int <= triangle_max;

		// end else if (triangle_int <= triangle_min) begin
		// 	// triangle_int <= triangle_min;
		// 	triangle_max <= amplitude_int * 2048;  //12b'011111111111';
		// 	triangle_min <= -amplitude_int * 2048; //12b'100000000001';

		// end

		if (triangle_int >= triangle_max || triangle_int <= triangle_min) begin
			cw_int <= CW_IN;
			ccw_int <= CCW_IN;
			triangle_max <= amplitude_int * 2048;  //12b'011111111111';
			triangle_min <= -amplitude_int * 2048; //12b'100000000001';
			// amplitude_int <= AMPLITUDE;
			if (triangle_int >= triangle_max) begin
				triangle_int <= triangle_max - amplitude_int;
				triangle_dir <= -amplitude_int;
			end else if (triangle_int <= triangle_min) begin
				triangle_int <= triangle_min + amplitude_int;
				triangle_dir <= amplitude_int;
			end

		end else begin
			triangle_int <= triangle_int + triangle_dir;
		end
		TRIANGLE <= triangle_int;
		CW_OUT <= cw_int;
		CCW_OUT <= ccw_int;
	end
endmodule
