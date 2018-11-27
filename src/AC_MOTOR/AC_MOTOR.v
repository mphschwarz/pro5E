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
	parameter sine_samples = 64;
	parameter clock_div_max = sine_samples - 1;
	parameter bits = 12;
	parameter ctr_min = -2**(bits - 1);
	parameter ctr_max = 2**(bits - 1);
	//
	assign EN1 = ENABLE;
	assign EN2 = ENABLE;
	//
	reg [11:0] sine_index;
	reg [2: 0] sine_quadrant;  //which quarter of sine is acttive
	reg signed [2:0] sine_sign;  //for negative sine values
	reg signed [2:0] sine_direction; //counting direction for sine
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
			sine[0] = 12'b000000000000; sine[1] = 12'b000011001011;
			sine[2] = 12'b000110010101; sine[3] = 12'b001001011011;
			sine[4] = 12'b001100011011; sine[5] = 12'b001111010011;
			sine[6] = 12'b010010000001; sine[7] = 12'b010100100100;
			sine[8] = 12'b010110111010; sine[9] = 12'b011001000001;
			sine[10] = 12'b011010111000; sine[11] = 12'b011100011110;
			sine[12] = 12'b011101110010; sine[13] = 12'b011110110011;
			sine[14] = 12'b011111100000; sine[15] = 12'b011111111010;
			sine[16] = 12'b011111111111; sine[17] = 12'b011111110000;
			sine[18] = 12'b011111001100; sine[19] = 12'b011110010101;
			sine[20] = 12'b011101001010; sine[21] = 12'b011011101101;
			sine[22] = 12'b011001111110; sine[23] = 12'b010111111111;
			sine[24] = 12'b010101110000; sine[25] = 12'b010011010100;
			sine[26] = 12'b010000101011; sine[27] = 12'b001101111000;
			sine[28] = 12'b001010111100; sine[29] = 12'b000111111001;
			sine[30] = 12'b000100110001; sine[31] = 12'b000001100110;
			sine[32] = 12'b111110011010; sine[33] = 12'b111011001111;
			sine[34] = 12'b111000000111; sine[35] = 12'b110101000100;
			sine[36] = 12'b110010001000; sine[37] = 12'b101111010101;
			sine[38] = 12'b101100101100; sine[39] = 12'b101010010000;
			sine[40] = 12'b101000000001; sine[41] = 12'b100110000010;
			sine[42] = 12'b100100010011; sine[43] = 12'b100010110110;
			sine[44] = 12'b100001101011; sine[45] = 12'b100000110100;
			sine[46] = 12'b100000010000; sine[47] = 12'b100000000001;
			sine[48] = 12'b100000000110; sine[49] = 12'b100000100000;
			sine[50] = 12'b100001001101; sine[51] = 12'b100010001110;
			sine[52] = 12'b100011100010; sine[53] = 12'b100101001000;
			sine[54] = 12'b100110111111; sine[55] = 12'b101001000110;
			sine[56] = 12'b101011011100; sine[57] = 12'b101101111111;
			sine[58] = 12'b110000101101; sine[59] = 12'b110011100101;
			sine[60] = 12'b110110100101; sine[61] = 12'b111001101011;
			sine[62] = 12'b111100110101; sine[63] = 12'b000000000000;
			clock_div <= 0;
			temp_frequency <= 2;
			temp_amplitude <= 1;
			sine_index <= 0;
			//
			OUT1 <= 0;
			OUT2 <= 0;
			ADC_LATCH <= 0;
			//
			cw_temp <= 1;
			ccw_temp <= 0;
			value_temp <= sine[0];
			adc_cmp_temp <= 0;
			adc_temp <= 0;
			en_adc <= 1;
			ctr <= 16383;
			ctr_dir <= 1;
			ctr_adc_latch <= 1;
		end
	//
	always @(posedge CLK) begin
		if (sine_quadrant == 0 || sine_quadrant == 2) sine_direction <= 1;
		else sine_direction <= -1;
		if (sine_quadrant == 0 || sine_quadrant == 1) sine_sign <= 1;
		else sine_direction <= -1;

		if (clock_div >= temp_frequency) begin
			clock_div <= 0;
			if (sine_index >= sine_samples) begin
				sine_quadrant <= sine_quadrant + 1;
				sine_index <= 0;
				value_temp <= sine[0];
			end else begin
				sine_index <= sine_index + 1;
				value_temp <= sine[sine_index];
			end
		end else begin
			clock_div <= clock_div + 1;
		end
	
		if (ctr == ctr_max || ctr == ctr_min) begin
			cw_temp <= CW;
			ccw_temp <= CCW;
			//temp_frequency <= FREQUENCY;
			//temp_amplitude <= AMPLITUDE;
		end
		//
		if (ctr == ctr_max) ctr_dir <= 0;
		if (ctr == ctr_min) ctr_dir <= 1;
		//
		if (ctr_dir) ctr <= ctr + 1;
		else ctr <= ctr - 1;	
		//
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
endmodule
