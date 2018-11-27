module AC_MOTOR(
	input CLK,
	input ENABLE,
	input CW,
	input CCW,
	//input [11:0] SINE,
	input [11:0] AMPLITUDE,
	input [11:0] FREQUENCY,
	input [11:0] ADC_CMP,
	input [11:0] ADC,
	output reg OUT1,
	output reg OUT2,
	output EN1,
	output EN2,	
	output reg ADC_LATCH);
	//
	parameter sine_samples = 64 * 4;
	parameter clock_div_max = sine_samples - 1;
	parameter bits = 12;
	parameter ctr_min = -2**(bits - 1);
	parameter ctr_max = 2**(bits - 1);
	//
	assign EN1 = ENABLE;
	assign EN2 = ENABLE;
	//
	reg [11:0] sine_index;
	// reg [1: 0] sine_quadrant;  //which quarter of sine is acttive
	// reg signed [2:0] sine_sign;  //for negative sine values
	// reg signed [2:0] sine_direction; //counting direction for sine
	reg [11:0] clock_div;
	reg [11:0] temp_frequency;
	reg [11:0] temp_amplitude;
	reg cw_temp;
	reg ccw_temp;
	reg signed [11:0] value_temp;
	reg [13:0] adc_cmp_temp;
	reg [11:0] adc_temp;
	reg en_adc;
	reg signed [bits-1:0] ctr;
	reg ctr_dir;
	reg [13:0] ctr_adc_latch;
	reg signed [bits-1:0] sine [sine_samples-1:0];
		initial begin
			// sine[0] = 12'b000010111100; sine[1] = 12'b000101111000;
			// sine[2] = 12'b001000110000; sine[3] = 12'b001011100011;
			// sine[4] = 12'b001110010000; sine[5] = 12'b010000110110;
			// sine[6] = 12'b010011010010; sine[7] = 12'b010101100011;
			// sine[8] = 12'b010111101001; sine[9] = 12'b011001100010;
			// sine[10] = 12'b011011001101; sine[11] = 12'b011100101001;
			// sine[12] = 12'b011101110101; sine[13] = 12'b011110110001;
			// sine[14] = 12'b011111011101; sine[15] = 12'b011111110111;
			sine[0] = 12'b000000110001; sine[1] = 12'b000001100010;
			sine[2] = 12'b000010010100; sine[3] = 12'b000011000101;
			sine[4] = 12'b000011110110; sine[5] = 12'b000100100111;
			sine[6] = 12'b000101011000; sine[7] = 12'b000110001001;
			sine[8] = 12'b000110111001; sine[9] = 12'b000111101010;
			sine[10] = 12'b001000011010; sine[11] = 12'b001001001001;
			sine[12] = 12'b001001111000; sine[13] = 12'b001010100111;
			sine[14] = 12'b001011010110; sine[15] = 12'b001100000100;
			sine[16] = 12'b001100110001; sine[17] = 12'b001101011111;
			sine[18] = 12'b001110001011; sine[19] = 12'b001110110111;
			sine[20] = 12'b001111100011; sine[21] = 12'b010000001110;
			sine[22] = 12'b010000111000; sine[23] = 12'b010001100010;
			sine[24] = 12'b010010001011; sine[25] = 12'b010010110011;
			sine[26] = 12'b010011011011; sine[27] = 12'b010100000010;
			sine[28] = 12'b010100101000; sine[29] = 12'b010101001110;
			sine[30] = 12'b010101110010; sine[31] = 12'b010110010110;
			sine[32] = 12'b010110111001; sine[33] = 12'b010111011011;
			sine[34] = 12'b010111111100; sine[35] = 12'b011000011101;
			sine[36] = 12'b011000111100; sine[37] = 12'b011001011011;
			sine[38] = 12'b011001111000; sine[39] = 12'b011010010101;
			sine[40] = 12'b011010110001; sine[41] = 12'b011011001011;
			sine[42] = 12'b011011100101; sine[43] = 12'b011011111101;
			sine[44] = 12'b011100010101; sine[45] = 12'b011100101011;
			sine[46] = 12'b011101000001; sine[47] = 12'b011101010101;
			sine[48] = 12'b011101101000; sine[49] = 12'b011101111010;
			sine[50] = 12'b011110001011; sine[51] = 12'b011110011011;
			sine[52] = 12'b011110101010; sine[53] = 12'b011110111000;
			sine[54] = 12'b011111000100; sine[55] = 12'b011111001111;
			sine[56] = 12'b011111011001; sine[57] = 12'b011111100010;
			sine[58] = 12'b011111101010; sine[59] = 12'b011111110001;
			sine[60] = 12'b011111110110; sine[61] = 12'b011111111010;
			sine[62] = 12'b011111111101; sine[63] = 12'b011111111111;
			clock_div <= 0;
			temp_frequency <= 0;
			temp_amplitude <= 1;
			sine_index <= 0;
			// sine_quadrant <= 0;
			// sine_direction <= 1;
			// sine_sign <= 1;
			//
			OUT1 <= 0;
			OUT2 <= 0;
			ADC_LATCH <= 0;
			//
			cw_temp <= 1;
			ccw_temp <= 0;
			value_temp <= 0;
			adc_cmp_temp <= 0;
			adc_temp <= 0;
			en_adc <= 1;
			ctr <= 16383;
			ctr_dir <= 1;
			ctr_adc_latch <= 1;
		end
	// sine control
	always @(posedge CLK) begin
		if (clock_div == temp_frequency) begin
			clock_div <= 0;
			if      (sine_index == 0)                        value_temp <= 12'b000000000000;
			else if (sine_index == sine_samples / 4     + 1) value_temp <= 12'b011111111111;
			else if (sine_index == sine_samples / 2     + 2) value_temp <= 12'b000000000000;
			else if (sine_index == sine_samples * 3 / 4 + 3) value_temp <= 12'b100000000001;
			else if (sine_index == sine_samples         + 4) value_temp <= 12'b000000000000;
			else if (sine_index >  0                        && sine_index < sine_samples     / 4 + 1) value_temp <=      sine[sine_index                    - 1];
			else if (sine_index >  sine_samples     / 4 + 1 && sine_index < sine_samples     / 2 + 2) value_temp <=      sine[sine_samples / 2 - sine_index + 1];
			else if (sine_index >  sine_samples     / 2 + 2 && sine_index < sine_samples * 3 / 4 + 3) value_temp <= -1 * sine[sine_index - sine_samples / 2 - 3];
			else if (sine_index >  sine_samples * 3 / 4 + 3 && sine_index < sine_samples         + 4) value_temp <= -1 * sine[sine_samples - sine_index     + 3];
			//sine_index <= sine_index + 1;
			//value_temp <= sine_sign * sine[sine_index];
			if (sine_index == sine_samples + 3) sine_index <= 0;
			else sine_index <= sine_index + 1;

		end else begin
			clock_div <= clock_div + 1;
		end

	end

	// comparator sine, counter
	always @(value_temp, ctr) begin
		if (value_temp >= ctr) begin
			if (cw_temp && !ccw_temp) begin
				OUT1 <= 1;
				OUT2 <= 0;
				end
			//	
			if (!cw_temp && ccw_temp) begin
				OUT1 <= 0;
				OUT2 <= 1;
				end
			//
			end
		else begin
            if (cw_temp && !ccw_temp) begin
				OUT1 <= 0;
				OUT2 <= 1;
				end
			if (!cw_temp && ccw_temp) begin
				OUT1 <= 1;
				OUT2 <= 0;
				end
		end

	end

	always @(posedge CLK) begin
		if (ctr == ctr_max || ctr == ctr_min) begin
			cw_temp <= CW;
			ccw_temp <= CCW;
			temp_frequency <= FREQUENCY;
			temp_amplitude <= AMPLITUDE;
		end
		//
		if (ctr == ctr_max) ctr_dir <= 0;
		if (ctr == ctr_min) ctr_dir <= 1;
		//
		if (ctr_dir) ctr <= ctr + 128;
		else ctr <= ctr - 128;	
		//
	end
endmodule
