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
	parameter sine_samples = 512 * 4;
	// parameter clock_div_max = sine_samples - 1;
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
	reg signed [11:0] temp_amplitude;
	reg cw_temp;
	reg ccw_temp;
	reg signed [11:0] value_temp;
	reg [13:0] adc_cmp_temp;
	reg [11:0] adc_temp;
	reg en_adc;
	reg signed [bits-1:0] ctr;
	reg ctr_dir;
	reg [13:0] ctr_adc_latch;
	reg signed [bits-1:0] sine [(sine_samples / 4) - 1:0];
		initial begin
			sine[0] = 12'b000000000110; sine[1] = 12'b000000001100;
			sine[2] = 12'b000000010010; sine[3] = 12'b000000011001;
			sine[4] = 12'b000000011111; sine[5] = 12'b000000100101;
			sine[6] = 12'b000000101011; sine[7] = 12'b000000110010;
			sine[8] = 12'b000000111000; sine[9] = 12'b000000111110;
			sine[10] = 12'b000001000100; sine[11] = 12'b000001001011;
			sine[12] = 12'b000001010001; sine[13] = 12'b000001010111;
			sine[14] = 12'b000001011110; sine[15] = 12'b000001100100;
			sine[16] = 12'b000001101010; sine[17] = 12'b000001110000;
			sine[18] = 12'b000001110111; sine[19] = 12'b000001111101;
			sine[20] = 12'b000010000011; sine[21] = 12'b000010001001;
			sine[22] = 12'b000010010000; sine[23] = 12'b000010010110;
			sine[24] = 12'b000010011100; sine[25] = 12'b000010100010;
			sine[26] = 12'b000010101001; sine[27] = 12'b000010101111;
			sine[28] = 12'b000010110101; sine[29] = 12'b000010111011;
			sine[30] = 12'b000011000010; sine[31] = 12'b000011001000;
			sine[32] = 12'b000011001110; sine[33] = 12'b000011010100;
			sine[34] = 12'b000011011011; sine[35] = 12'b000011100001;
			sine[36] = 12'b000011100111; sine[37] = 12'b000011101101;
			sine[38] = 12'b000011110011; sine[39] = 12'b000011111010;
			sine[40] = 12'b000100000000; sine[41] = 12'b000100000110;
			sine[42] = 12'b000100001100; sine[43] = 12'b000100010011;
			sine[44] = 12'b000100011001; sine[45] = 12'b000100011111;
			sine[46] = 12'b000100100101; sine[47] = 12'b000100101011;
			sine[48] = 12'b000100110010; sine[49] = 12'b000100111000;
			sine[50] = 12'b000100111110; sine[51] = 12'b000101000100;
			sine[52] = 12'b000101001010; sine[53] = 12'b000101010001;
			sine[54] = 12'b000101010111; sine[55] = 12'b000101011101;
			sine[56] = 12'b000101100011; sine[57] = 12'b000101101001;
			sine[58] = 12'b000101101111; sine[59] = 12'b000101110110;
			sine[60] = 12'b000101111100; sine[61] = 12'b000110000010;
			sine[62] = 12'b000110001000; sine[63] = 12'b000110001110;
			sine[64] = 12'b000110010100; sine[65] = 12'b000110011011;
			sine[66] = 12'b000110100001; sine[67] = 12'b000110100111;
			sine[68] = 12'b000110101101; sine[69] = 12'b000110110011;
			sine[70] = 12'b000110111001; sine[71] = 12'b000110111111;
			sine[72] = 12'b000111000101; sine[73] = 12'b000111001100;
			sine[74] = 12'b000111010010; sine[75] = 12'b000111011000;
			sine[76] = 12'b000111011110; sine[77] = 12'b000111100100;
			sine[78] = 12'b000111101010; sine[79] = 12'b000111110000;
			sine[80] = 12'b000111110110; sine[81] = 12'b000111111100;
			sine[82] = 12'b001000000010; sine[83] = 12'b001000001000;
			sine[84] = 12'b001000001111; sine[85] = 12'b001000010101;
			sine[86] = 12'b001000011011; sine[87] = 12'b001000100001;
			sine[88] = 12'b001000100111; sine[89] = 12'b001000101101;
			sine[90] = 12'b001000110011; sine[91] = 12'b001000111001;
			sine[92] = 12'b001000111111; sine[93] = 12'b001001000101;
			sine[94] = 12'b001001001011; sine[95] = 12'b001001010001;
			sine[96] = 12'b001001010111; sine[97] = 12'b001001011101;
			sine[98] = 12'b001001100011; sine[99] = 12'b001001101001;
			sine[100] = 12'b001001101111; sine[101] = 12'b001001110101;
			sine[102] = 12'b001001111011; sine[103] = 12'b001010000001;
			sine[104] = 12'b001010000111; sine[105] = 12'b001010001101;
			sine[106] = 12'b001010010011; sine[107] = 12'b001010011000;
			sine[108] = 12'b001010011110; sine[109] = 12'b001010100100;
			sine[110] = 12'b001010101010; sine[111] = 12'b001010110000;
			sine[112] = 12'b001010110110; sine[113] = 12'b001010111100;
			sine[114] = 12'b001011000010; sine[115] = 12'b001011001000;
			sine[116] = 12'b001011001110; sine[117] = 12'b001011010011;
			sine[118] = 12'b001011011001; sine[119] = 12'b001011011111;
			sine[120] = 12'b001011100101; sine[121] = 12'b001011101011;
			sine[122] = 12'b001011110001; sine[123] = 12'b001011110111;
			sine[124] = 12'b001011111100; sine[125] = 12'b001100000010;
			sine[126] = 12'b001100001000; sine[127] = 12'b001100001110;
			sine[128] = 12'b001100010100; sine[129] = 12'b001100011001;
			sine[130] = 12'b001100011111; sine[131] = 12'b001100100101;
			sine[132] = 12'b001100101011; sine[133] = 12'b001100110000;
			sine[134] = 12'b001100110110; sine[135] = 12'b001100111100;
			sine[136] = 12'b001101000010; sine[137] = 12'b001101000111;
			sine[138] = 12'b001101001101; sine[139] = 12'b001101010011;
			sine[140] = 12'b001101011000; sine[141] = 12'b001101011110;
			sine[142] = 12'b001101100100; sine[143] = 12'b001101101010;
			sine[144] = 12'b001101101111; sine[145] = 12'b001101110101;
			sine[146] = 12'b001101111011; sine[147] = 12'b001110000000;
			sine[148] = 12'b001110000110; sine[149] = 12'b001110001011;
			sine[150] = 12'b001110010001; sine[151] = 12'b001110010111;
			sine[152] = 12'b001110011100; sine[153] = 12'b001110100010;
			sine[154] = 12'b001110100111; sine[155] = 12'b001110101101;
			sine[156] = 12'b001110110011; sine[157] = 12'b001110111000;
			sine[158] = 12'b001110111110; sine[159] = 12'b001111000011;
			sine[160] = 12'b001111001001; sine[161] = 12'b001111001110;
			sine[162] = 12'b001111010100; sine[163] = 12'b001111011001;
			sine[164] = 12'b001111011111; sine[165] = 12'b001111100100;
			sine[166] = 12'b001111101010; sine[167] = 12'b001111101111;
			sine[168] = 12'b001111110101; sine[169] = 12'b001111111010;
			sine[170] = 12'b001111111111; sine[171] = 12'b010000000101;
			sine[172] = 12'b010000001010; sine[173] = 12'b010000010000;
			sine[174] = 12'b010000010101; sine[175] = 12'b010000011011;
			sine[176] = 12'b010000100000; sine[177] = 12'b010000100101;
			sine[178] = 12'b010000101011; sine[179] = 12'b010000110000;
			sine[180] = 12'b010000110101; sine[181] = 12'b010000111011;
			sine[182] = 12'b010001000000; sine[183] = 12'b010001000101;
			sine[184] = 12'b010001001011; sine[185] = 12'b010001010000;
			sine[186] = 12'b010001010101; sine[187] = 12'b010001011010;
			sine[188] = 12'b010001100000; sine[189] = 12'b010001100101;
			sine[190] = 12'b010001101010; sine[191] = 12'b010001101111;
			sine[192] = 12'b010001110101; sine[193] = 12'b010001111010;
			sine[194] = 12'b010001111111; sine[195] = 12'b010010000100;
			sine[196] = 12'b010010001001; sine[197] = 12'b010010001110;
			sine[198] = 12'b010010010100; sine[199] = 12'b010010011001;
			sine[200] = 12'b010010011110; sine[201] = 12'b010010100011;
			sine[202] = 12'b010010101000; sine[203] = 12'b010010101101;
			sine[204] = 12'b010010110010; sine[205] = 12'b010010110111;
			sine[206] = 12'b010010111100; sine[207] = 12'b010011000001;
			sine[208] = 12'b010011000110; sine[209] = 12'b010011001100;
			sine[210] = 12'b010011010001; sine[211] = 12'b010011010110;
			sine[212] = 12'b010011011011; sine[213] = 12'b010011011111;
			sine[214] = 12'b010011100100; sine[215] = 12'b010011101001;
			sine[216] = 12'b010011101110; sine[217] = 12'b010011110011;
			sine[218] = 12'b010011111000; sine[219] = 12'b010011111101;
			sine[220] = 12'b010100000010; sine[221] = 12'b010100000111;
			sine[222] = 12'b010100001100; sine[223] = 12'b010100010001;
			sine[224] = 12'b010100010101; sine[225] = 12'b010100011010;
			sine[226] = 12'b010100011111; sine[227] = 12'b010100100100;
			sine[228] = 12'b010100101001; sine[229] = 12'b010100101110;
			sine[230] = 12'b010100110010; sine[231] = 12'b010100110111;
			sine[232] = 12'b010100111100; sine[233] = 12'b010101000001;
			sine[234] = 12'b010101000101; sine[235] = 12'b010101001010;
			sine[236] = 12'b010101001111; sine[237] = 12'b010101010011;
			sine[238] = 12'b010101011000; sine[239] = 12'b010101011101;
			sine[240] = 12'b010101100001; sine[241] = 12'b010101100110;
			sine[242] = 12'b010101101011; sine[243] = 12'b010101101111;
			sine[244] = 12'b010101110100; sine[245] = 12'b010101111000;
			sine[246] = 12'b010101111101; sine[247] = 12'b010110000001;
			sine[248] = 12'b010110000110; sine[249] = 12'b010110001011;
			sine[250] = 12'b010110001111; sine[251] = 12'b010110010100;
			sine[252] = 12'b010110011000; sine[253] = 12'b010110011101;
			sine[254] = 12'b010110100001; sine[255] = 12'b010110100101;
			sine[256] = 12'b010110101010; sine[257] = 12'b010110101110;
			sine[258] = 12'b010110110011; sine[259] = 12'b010110110111;
			sine[260] = 12'b010110111011; sine[261] = 12'b010111000000;
			sine[262] = 12'b010111000100; sine[263] = 12'b010111001001;
			sine[264] = 12'b010111001101; sine[265] = 12'b010111010001;
			sine[266] = 12'b010111010101; sine[267] = 12'b010111011010;
			sine[268] = 12'b010111011110; sine[269] = 12'b010111100010;
			sine[270] = 12'b010111100111; sine[271] = 12'b010111101011;
			sine[272] = 12'b010111101111; sine[273] = 12'b010111110011;
			sine[274] = 12'b010111110111; sine[275] = 12'b010111111011;
			sine[276] = 12'b011000000000; sine[277] = 12'b011000000100;
			sine[278] = 12'b011000001000; sine[279] = 12'b011000001100;
			sine[280] = 12'b011000010000; sine[281] = 12'b011000010100;
			sine[282] = 12'b011000011000; sine[283] = 12'b011000011100;
			sine[284] = 12'b011000100000; sine[285] = 12'b011000100100;
			sine[286] = 12'b011000101000; sine[287] = 12'b011000101100;
			sine[288] = 12'b011000110000; sine[289] = 12'b011000110100;
			sine[290] = 12'b011000111000; sine[291] = 12'b011000111100;
			sine[292] = 12'b011001000000; sine[293] = 12'b011001000100;
			sine[294] = 12'b011001001000; sine[295] = 12'b011001001100;
			sine[296] = 12'b011001010000; sine[297] = 12'b011001010100;
			sine[298] = 12'b011001010111; sine[299] = 12'b011001011011;
			sine[300] = 12'b011001011111; sine[301] = 12'b011001100011;
			sine[302] = 12'b011001100110; sine[303] = 12'b011001101010;
			sine[304] = 12'b011001101110; sine[305] = 12'b011001110010;
			sine[306] = 12'b011001110101; sine[307] = 12'b011001111001;
			sine[308] = 12'b011001111101; sine[309] = 12'b011010000000;
			sine[310] = 12'b011010000100; sine[311] = 12'b011010001000;
			sine[312] = 12'b011010001011; sine[313] = 12'b011010001111;
			sine[314] = 12'b011010010011; sine[315] = 12'b011010010110;
			sine[316] = 12'b011010011010; sine[317] = 12'b011010011101;
			sine[318] = 12'b011010100001; sine[319] = 12'b011010100100;
			sine[320] = 12'b011010101000; sine[321] = 12'b011010101011;
			sine[322] = 12'b011010101111; sine[323] = 12'b011010110010;
			sine[324] = 12'b011010110101; sine[325] = 12'b011010111001;
			sine[326] = 12'b011010111100; sine[327] = 12'b011011000000;
			sine[328] = 12'b011011000011; sine[329] = 12'b011011000110;
			sine[330] = 12'b011011001010; sine[331] = 12'b011011001101;
			sine[332] = 12'b011011010000; sine[333] = 12'b011011010100;
			sine[334] = 12'b011011010111; sine[335] = 12'b011011011010;
			sine[336] = 12'b011011011101; sine[337] = 12'b011011100000;
			sine[338] = 12'b011011100100; sine[339] = 12'b011011100111;
			sine[340] = 12'b011011101010; sine[341] = 12'b011011101101;
			sine[342] = 12'b011011110000; sine[343] = 12'b011011110011;
			sine[344] = 12'b011011110110; sine[345] = 12'b011011111010;
			sine[346] = 12'b011011111101; sine[347] = 12'b011100000000;
			sine[348] = 12'b011100000011; sine[349] = 12'b011100000110;
			sine[350] = 12'b011100001001; sine[351] = 12'b011100001100;
			sine[352] = 12'b011100001111; sine[353] = 12'b011100010010;
			sine[354] = 12'b011100010100; sine[355] = 12'b011100010111;
			sine[356] = 12'b011100011010; sine[357] = 12'b011100011101;
			sine[358] = 12'b011100100000; sine[359] = 12'b011100100011;
			sine[360] = 12'b011100100110; sine[361] = 12'b011100101000;
			sine[362] = 12'b011100101011; sine[363] = 12'b011100101110;
			sine[364] = 12'b011100110001; sine[365] = 12'b011100110100;
			sine[366] = 12'b011100110110; sine[367] = 12'b011100111001;
			sine[368] = 12'b011100111100; sine[369] = 12'b011100111110;
			sine[370] = 12'b011101000001; sine[371] = 12'b011101000100;
			sine[372] = 12'b011101000110; sine[373] = 12'b011101001001;
			sine[374] = 12'b011101001011; sine[375] = 12'b011101001110;
			sine[376] = 12'b011101010000; sine[377] = 12'b011101010011;
			sine[378] = 12'b011101010110; sine[379] = 12'b011101011000;
			sine[380] = 12'b011101011010; sine[381] = 12'b011101011101;
			sine[382] = 12'b011101011111; sine[383] = 12'b011101100010;
			sine[384] = 12'b011101100100; sine[385] = 12'b011101100111;
			sine[386] = 12'b011101101001; sine[387] = 12'b011101101011;
			sine[388] = 12'b011101101110; sine[389] = 12'b011101110000;
			sine[390] = 12'b011101110010; sine[391] = 12'b011101110101;
			sine[392] = 12'b011101110111; sine[393] = 12'b011101111001;
			sine[394] = 12'b011101111011; sine[395] = 12'b011101111101;
			sine[396] = 12'b011110000000; sine[397] = 12'b011110000010;
			sine[398] = 12'b011110000100; sine[399] = 12'b011110000110;
			sine[400] = 12'b011110001000; sine[401] = 12'b011110001010;
			sine[402] = 12'b011110001100; sine[403] = 12'b011110001110;
			sine[404] = 12'b011110010001; sine[405] = 12'b011110010011;
			sine[406] = 12'b011110010101; sine[407] = 12'b011110010111;
			sine[408] = 12'b011110011001; sine[409] = 12'b011110011010;
			sine[410] = 12'b011110011100; sine[411] = 12'b011110011110;
			sine[412] = 12'b011110100000; sine[413] = 12'b011110100010;
			sine[414] = 12'b011110100100; sine[415] = 12'b011110100110;
			sine[416] = 12'b011110101000; sine[417] = 12'b011110101001;
			sine[418] = 12'b011110101011; sine[419] = 12'b011110101101;
			sine[420] = 12'b011110101111; sine[421] = 12'b011110110001;
			sine[422] = 12'b011110110010; sine[423] = 12'b011110110100;
			sine[424] = 12'b011110110110; sine[425] = 12'b011110110111;
			sine[426] = 12'b011110111001; sine[427] = 12'b011110111011;
			sine[428] = 12'b011110111100; sine[429] = 12'b011110111110;
			sine[430] = 12'b011110111111; sine[431] = 12'b011111000001;
			sine[432] = 12'b011111000010; sine[433] = 12'b011111000100;
			sine[434] = 12'b011111000101; sine[435] = 12'b011111000111;
			sine[436] = 12'b011111001000; sine[437] = 12'b011111001010;
			sine[438] = 12'b011111001011; sine[439] = 12'b011111001101;
			sine[440] = 12'b011111001110; sine[441] = 12'b011111001111;
			sine[442] = 12'b011111010001; sine[443] = 12'b011111010010;
			sine[444] = 12'b011111010011; sine[445] = 12'b011111010101;
			sine[446] = 12'b011111010110; sine[447] = 12'b011111010111;
			sine[448] = 12'b011111011000; sine[449] = 12'b011111011010;
			sine[450] = 12'b011111011011; sine[451] = 12'b011111011100;
			sine[452] = 12'b011111011101; sine[453] = 12'b011111011110;
			sine[454] = 12'b011111011111; sine[455] = 12'b011111100000;
			sine[456] = 12'b011111100001; sine[457] = 12'b011111100011;
			sine[458] = 12'b011111100100; sine[459] = 12'b011111100101;
			sine[460] = 12'b011111100110; sine[461] = 12'b011111100111;
			sine[462] = 12'b011111101000; sine[463] = 12'b011111101000;
			sine[464] = 12'b011111101001; sine[465] = 12'b011111101010;
			sine[466] = 12'b011111101011; sine[467] = 12'b011111101100;
			sine[468] = 12'b011111101101; sine[469] = 12'b011111101110;
			sine[470] = 12'b011111101111; sine[471] = 12'b011111101111;
			sine[472] = 12'b011111110000; sine[473] = 12'b011111110001;
			sine[474] = 12'b011111110010; sine[475] = 12'b011111110010;
			sine[476] = 12'b011111110011; sine[477] = 12'b011111110100;
			sine[478] = 12'b011111110100; sine[479] = 12'b011111110101;
			sine[480] = 12'b011111110110; sine[481] = 12'b011111110110;
			sine[482] = 12'b011111110111; sine[483] = 12'b011111110111;
			sine[484] = 12'b011111111000; sine[485] = 12'b011111111001;
			sine[486] = 12'b011111111001; sine[487] = 12'b011111111010;
			sine[488] = 12'b011111111010; sine[489] = 12'b011111111010;
			sine[490] = 12'b011111111011; sine[491] = 12'b011111111011;
			sine[492] = 12'b011111111100; sine[493] = 12'b011111111100;
			sine[494] = 12'b011111111100; sine[495] = 12'b011111111101;
			sine[496] = 12'b011111111101; sine[497] = 12'b011111111101;
			sine[498] = 12'b011111111110; sine[499] = 12'b011111111110;
			sine[500] = 12'b011111111110; sine[501] = 12'b011111111110;
			sine[502] = 12'b011111111111; sine[503] = 12'b011111111111;
			sine[504] = 12'b011111111111; sine[505] = 12'b011111111111;
			sine[506] = 12'b011111111111; sine[507] = 12'b011111111111;
			sine[508] = 12'b011111111111; sine[509] = 12'b011111111111;
			sine[510] = 12'b011111111111; sine[511] = 12'b011111111111;
			clock_div <= 0;
			// temp_frequency <= 5000; // 27 Hz
			temp_frequency <= 500; // 48 Hz
			temp_amplitude <= 2;
			sine_index <= 0;
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
			// ctr <= 16383;
			ctr <= 0;
			ctr_dir <= 1;
			ctr_adc_latch <= 1;
		end
	// sine control
	always @(posedge CLK) begin
		if (clock_div >= temp_frequency) begin
			clock_div <= 0;
			if      (sine_index == 0)                        value_temp <= 12'b000000000000 * temp_amplitude / 4;
			else if (sine_index == sine_samples / 4     + 1) value_temp <= 12'b011111111111 * temp_amplitude / 4;
			else if (sine_index == sine_samples / 2     + 2) value_temp <= 12'b000000000000 * temp_amplitude / 4;
			else if (sine_index == sine_samples * 3 / 4 + 3) value_temp <= 12'b100000000001 * temp_amplitude / 4;
			else if (sine_index > 0                        && sine_index < sine_samples     / 4 + 1) value_temp <=  sine[sine_index                    - 1] * temp_amplitude / 4;
			else if (sine_index > sine_samples     / 4 + 1 && sine_index < sine_samples     / 2 + 2) value_temp <=  sine[sine_samples / 2 - sine_index + 1] * temp_amplitude / 4;
			else if (sine_index > sine_samples     / 2 + 2 && sine_index < sine_samples * 3 / 4 + 3) value_temp <= -sine[sine_index - sine_samples / 2 - 3] * temp_amplitude / 4;
			else if (sine_index > sine_samples * 3 / 4 + 3 && sine_index < sine_samples         + 4) value_temp <= -sine[sine_samples - sine_index     + 3] * temp_amplitude / 4;
			// value_temp <= 12'b000000000000; // für triangle frequency testing
			if (sine_index == sine_samples + 3) sine_index <= 0;
			else sine_index <= sine_index + 1;

		end else begin
			clock_div <= clock_div + 1;
		end

	end

	// comparator sine, counter
	always @(value_temp, ctr) begin
		adc_temp[11:0] <= ADC[11:0];
		if (adc_temp > adc_cmp_temp) en_adc <= 0;

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
		if (ctr == ctr_max) ADC_LATCH <= 1;
		if (ADC_LATCH) ctr_adc_latch <= ctr_adc_latch + 1;	
		if (ctr_adc_latch == 50)
			begin
			ctr_adc_latch <= 1;
			ADC_LATCH <= 0;
			end		
	end

	always @(posedge CLK) begin
		if (ctr >= ctr_max || ctr <= ctr_min) begin
			cw_temp <= CW;
			ccw_temp <= CCW;
			temp_frequency <= FREQUENCY;
		 	temp_amplitude <= AMPLITUDE;
		end
		//
		if (ctr == ctr_max) ctr_dir <= 0;
		if (ctr == ctr_min) ctr_dir <= 1;
		//
		if (ctr_dir) ctr <= ctr + 1;
		else ctr <= ctr - 1;
		// ctr <= 12'b000000000000; // for sinus frequency testing
	end
endmodule
