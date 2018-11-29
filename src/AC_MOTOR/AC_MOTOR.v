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
	parameter sine_samples = 128 * 4;
	parameter clock_div_max = sine_samples - 1;
	parameter bits = 12;
	parameter ctr_min = -2**(bits - 1) + 2;
	parameter ctr_max = 2**(bits - 1) - 2;
	//
	assign EN1 = 1;
	assign EN2 = 1;
	//
	reg [13:0] sine_index;
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
	reg signed [bits-1:0] sine [sine_samples * 4 - 1:0];
		initial begin
			sine[0] = 12'b000000001100; sine[1] = 12'b000000011001;
			sine[2] = 12'b000000100101; sine[3] = 12'b000000110010;
			sine[4] = 12'b000000111110; sine[5] = 12'b000001001011;
			sine[6] = 12'b000001010111; sine[7] = 12'b000001100100;
			sine[8] = 12'b000001110000; sine[9] = 12'b000001111101;
			sine[10] = 12'b000010001001; sine[11] = 12'b000010010110;
			sine[12] = 12'b000010100010; sine[13] = 12'b000010101111;
			sine[14] = 12'b000010111011; sine[15] = 12'b000011000111;
			sine[16] = 12'b000011010100; sine[17] = 12'b000011100000;
			sine[18] = 12'b000011101101; sine[19] = 12'b000011111001;
			sine[20] = 12'b000100000110; sine[21] = 12'b000100010010;
			sine[22] = 12'b000100011110; sine[23] = 12'b000100101011;
			sine[24] = 12'b000100110111; sine[25] = 12'b000101000100;
			sine[26] = 12'b000101010000; sine[27] = 12'b000101011100;
			sine[28] = 12'b000101101001; sine[29] = 12'b000101110101;
			sine[30] = 12'b000110000001; sine[31] = 12'b000110001110;
			sine[32] = 12'b000110011010; sine[33] = 12'b000110100110;
			sine[34] = 12'b000110110010; sine[35] = 12'b000110111111;
			sine[36] = 12'b000111001011; sine[37] = 12'b000111010111;
			sine[38] = 12'b000111100011; sine[39] = 12'b000111101111;
			sine[40] = 12'b000111111011; sine[41] = 12'b001000000111;
			sine[42] = 12'b001000010100; sine[43] = 12'b001000100000;
			sine[44] = 12'b001000101100; sine[45] = 12'b001000111000;
			sine[46] = 12'b001001000100; sine[47] = 12'b001001010000;
			sine[48] = 12'b001001011100; sine[49] = 12'b001001101000;
			sine[50] = 12'b001001110100; sine[51] = 12'b001010000000;
			sine[52] = 12'b001010001011; sine[53] = 12'b001010010111;
			sine[54] = 12'b001010100011; sine[55] = 12'b001010101111;
			sine[56] = 12'b001010111011; sine[57] = 12'b001011000110;
			sine[58] = 12'b001011010010; sine[59] = 12'b001011011110;
			sine[60] = 12'b001011101001; sine[61] = 12'b001011110101;
			sine[62] = 12'b001100000001; sine[63] = 12'b001100001100;
			sine[64] = 12'b001100011000; sine[65] = 12'b001100100011;
			sine[66] = 12'b001100101111; sine[67] = 12'b001100111010;
			sine[68] = 12'b001101000110; sine[69] = 12'b001101010001;
			sine[70] = 12'b001101011101; sine[71] = 12'b001101101000;
			sine[72] = 12'b001101110011; sine[73] = 12'b001101111111;
			sine[74] = 12'b001110001010; sine[75] = 12'b001110010101;
			sine[76] = 12'b001110100000; sine[77] = 12'b001110101011;
			sine[78] = 12'b001110110110; sine[79] = 12'b001111000001;
			sine[80] = 12'b001111001101; sine[81] = 12'b001111010111;
			sine[82] = 12'b001111100010; sine[83] = 12'b001111101101;
			sine[84] = 12'b001111111000; sine[85] = 12'b010000000011;
			sine[86] = 12'b010000001110; sine[87] = 12'b010000011001;
			sine[88] = 12'b010000100011; sine[89] = 12'b010000101110;
			sine[90] = 12'b010000111001; sine[91] = 12'b010001000011;
			sine[92] = 12'b010001001110; sine[93] = 12'b010001011000;
			sine[94] = 12'b010001100011; sine[95] = 12'b010001101101;
			sine[96] = 12'b010001111000; sine[97] = 12'b010010000010;
			sine[98] = 12'b010010001100; sine[99] = 12'b010010010111;
			sine[100] = 12'b010010100001; sine[101] = 12'b010010101011;
			sine[102] = 12'b010010110101; sine[103] = 12'b010010111111;
			sine[104] = 12'b010011001001; sine[105] = 12'b010011010011;
			sine[106] = 12'b010011011101; sine[107] = 12'b010011100111;
			sine[108] = 12'b010011110001; sine[109] = 12'b010011111011;
			sine[110] = 12'b010100000101; sine[111] = 12'b010100001110;
			sine[112] = 12'b010100011000; sine[113] = 12'b010100100010;
			sine[114] = 12'b010100101011; sine[115] = 12'b010100110101;
			sine[116] = 12'b010100111110; sine[117] = 12'b010101001000;
			sine[118] = 12'b010101010001; sine[119] = 12'b010101011010;
			sine[120] = 12'b010101100100; sine[121] = 12'b010101101101;
			sine[122] = 12'b010101110110; sine[123] = 12'b010101111111;
			sine[124] = 12'b010110001000; sine[125] = 12'b010110010001;
			sine[126] = 12'b010110011010; sine[127] = 12'b010110100011;
			sine[128] = 12'b010110101100; sine[129] = 12'b010110110101;
			sine[130] = 12'b010110111110; sine[131] = 12'b010111000110;
			sine[132] = 12'b010111001111; sine[133] = 12'b010111011000;
			sine[134] = 12'b010111100000; sine[135] = 12'b010111101000;
			sine[136] = 12'b010111110001; sine[137] = 12'b010111111001;
			sine[138] = 12'b011000000010; sine[139] = 12'b011000001010;
			sine[140] = 12'b011000010010; sine[141] = 12'b011000011010;
			sine[142] = 12'b011000100010; sine[143] = 12'b011000101010;
			sine[144] = 12'b011000110010; sine[145] = 12'b011000111010;
			sine[146] = 12'b011001000010; sine[147] = 12'b011001001010;
			sine[148] = 12'b011001010001; sine[149] = 12'b011001011001;
			sine[150] = 12'b011001100001; sine[151] = 12'b011001101000;
			sine[152] = 12'b011001101111; sine[153] = 12'b011001110111;
			sine[154] = 12'b011001111110; sine[155] = 12'b011010000110;
			sine[156] = 12'b011010001101; sine[157] = 12'b011010010100;
			sine[158] = 12'b011010011011; sine[159] = 12'b011010100010;
			sine[160] = 12'b011010101001; sine[161] = 12'b011010110000;
			sine[162] = 12'b011010110111; sine[163] = 12'b011010111101;
			sine[164] = 12'b011011000100; sine[165] = 12'b011011001011;
			sine[166] = 12'b011011010001; sine[167] = 12'b011011011000;
			sine[168] = 12'b011011011110; sine[169] = 12'b011011100101;
			sine[170] = 12'b011011101011; sine[171] = 12'b011011110001;
			sine[172] = 12'b011011110111; sine[173] = 12'b011011111110;
			sine[174] = 12'b011100000100; sine[175] = 12'b011100001010;
			sine[176] = 12'b011100010000; sine[177] = 12'b011100010101;
			sine[178] = 12'b011100011011; sine[179] = 12'b011100100001;
			sine[180] = 12'b011100100110; sine[181] = 12'b011100101100;
			sine[182] = 12'b011100110010; sine[183] = 12'b011100110111;
			sine[184] = 12'b011100111100; sine[185] = 12'b011101000010;
			sine[186] = 12'b011101000111; sine[187] = 12'b011101001100;
			sine[188] = 12'b011101010001; sine[189] = 12'b011101010110;
			sine[190] = 12'b011101011011; sine[191] = 12'b011101100000;
			sine[192] = 12'b011101100101; sine[193] = 12'b011101101010;
			sine[194] = 12'b011101101110; sine[195] = 12'b011101110011;
			sine[196] = 12'b011101110111; sine[197] = 12'b011101111100;
			sine[198] = 12'b011110000000; sine[199] = 12'b011110000100;
			sine[200] = 12'b011110001001; sine[201] = 12'b011110001101;
			sine[202] = 12'b011110010001; sine[203] = 12'b011110010101;
			sine[204] = 12'b011110011001; sine[205] = 12'b011110011101;
			sine[206] = 12'b011110100001; sine[207] = 12'b011110100100;
			sine[208] = 12'b011110101000; sine[209] = 12'b011110101100;
			sine[210] = 12'b011110101111; sine[211] = 12'b011110110011;
			sine[212] = 12'b011110110110; sine[213] = 12'b011110111001;
			sine[214] = 12'b011110111100; sine[215] = 12'b011111000000;
			sine[216] = 12'b011111000011; sine[217] = 12'b011111000110;
			sine[218] = 12'b011111001001; sine[219] = 12'b011111001011;
			sine[220] = 12'b011111001110; sine[221] = 12'b011111010001;
			sine[222] = 12'b011111010011; sine[223] = 12'b011111010110;
			sine[224] = 12'b011111011000; sine[225] = 12'b011111011011;
			sine[226] = 12'b011111011101; sine[227] = 12'b011111011111;
			sine[228] = 12'b011111100010; sine[229] = 12'b011111100100;
			sine[230] = 12'b011111100110; sine[231] = 12'b011111101000;
			sine[232] = 12'b011111101010; sine[233] = 12'b011111101011;
			sine[234] = 12'b011111101101; sine[235] = 12'b011111101111;
			sine[236] = 12'b011111110000; sine[237] = 12'b011111110010;
			sine[238] = 12'b011111110011; sine[239] = 12'b011111110100;
			sine[240] = 12'b011111110110; sine[241] = 12'b011111110111;
			sine[242] = 12'b011111111000; sine[243] = 12'b011111111001;
			sine[244] = 12'b011111111010; sine[245] = 12'b011111111011;
			sine[246] = 12'b011111111100; sine[247] = 12'b011111111100;
			sine[248] = 12'b011111111101; sine[249] = 12'b011111111110;
			sine[250] = 12'b011111111110; sine[251] = 12'b011111111111;
			sine[252] = 12'b011111111111; sine[253] = 12'b011111111111;
			sine[254] = 12'b011111111111; sine[255] = 12'b011111111111;

			clock_div <= 0;
			// temp_frequency <= 1000; // 48 Hz
			temp_frequency <= 100; // 48 Hz
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
			else if (sine_index > 0                        && sine_index < sine_samples     / 4 + 1) value_temp <=  sine[sine_index                    - 1];
			else if (sine_index > sine_samples     / 4 + 1 && sine_index < sine_samples     / 2 + 2) value_temp <=  sine[sine_samples / 2 - sine_index + 1];
			else if (sine_index > sine_samples     / 2 + 2 && sine_index < sine_samples * 3 / 4 + 3) value_temp <= -sine[sine_index - sine_samples / 2 - 3];
			else if (sine_index > sine_samples * 3 / 4 + 3 && sine_index < sine_samples         + 4) value_temp <= -sine[sine_samples - sine_index     + 3];
			//value_temp = value_temp / temp_amplitude;
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
		// adc_temp[11:0] <= ADC[11:0];
		// if (adc_temp > adc_cmp_temp) en_adc <= 0;

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
		// if (ctr == 16383) ADC_LATCH <= 1;
		// if (ADC_LATCH) ctr_adc_latch <= ctr_adc_latch + 1;	
		// if (ctr_adc_latch == 50)
		// 	begin
		// 	ctr_adc_latch <= 1;
		// 	ADC_LATCH <= 0;
		// 	end		
	end

	always @(posedge CLK) begin
		if (ctr >= ctr_max || ctr <= ctr_min) begin
			cw_temp <= CW;
			ccw_temp <= CCW;
			// temp_frequency <= FREQUENCY;
			// temp_amplitude <= AMPLITUDE;
		end
		//
		if (ctr == ctr_max) ctr_dir <= 0;
		if (ctr == ctr_min) ctr_dir <= 1;
		//
		if (ctr_dir) ctr <= ctr + 1;
		else ctr <= ctr - 1;
		//
	end
endmodule
