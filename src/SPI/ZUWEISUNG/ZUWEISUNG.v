////////////////////////////////////////////////////////////////////////////////////////////
module DATA_IN_VAR_FT2232(
	input LED7,
	input LED6,
	input LED5,
	input LED4,
	input LED3,
	input LED2,
	input LED1,
	input LED0,
	input [7:0] MIN_ZEHNER,
	input [7:0] MIN_EINER,
	input [7:0] SEK_ZEHNER,
	input [7:0] SEK_EINER,
	input [7:0] SEK_ZEHNTEL,
	input [7:0] SEK_HUNDERTSTEL,
	input [7:0] SEK_TAUSENDSTEL,
	input [31:0] COUNTER,
	//
	output [255:0] DATA
	);
	//
	assign DATA[000] = LED7;
	assign DATA[001] = LED6;
	assign DATA[002] = LED5;
	assign DATA[003] = LED4;
	assign DATA[004] = LED3;
	assign DATA[005] = LED2;
	assign DATA[006] = LED1;
	assign DATA[007] = LED0;
	//
	assign DATA[015:008] = MIN_ZEHNER[7:0];
	assign DATA[023:016] = MIN_EINER[7:0];
	assign DATA[031:024] = SEK_ZEHNER[7:0];
	assign DATA[039:032] = SEK_EINER[7:0];
	assign DATA[047:040] = SEK_ZEHNTEL[7:0];
	assign DATA[055:048] = SEK_HUNDERTSTEL[7:0];	
	assign DATA[063:056] = SEK_TAUSENDSTEL[7:0];		
	//
	assign DATA[095:064] = COUNTER[31:0];	
	//
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
module DATA_OUT_VAR_FT2232(
	input [255:0] DATA,
	//
	output SW7,
	output SW6,
	output SW5,
	output SW4,
	output SW3,
	output SW2,
	output SW1,
	output SW0
	);
	//
	assign SW7 = DATA[000];
	assign SW6 = DATA[001];
	assign SW5 = DATA[002];
	assign SW4 = DATA[003];
	assign SW3 = DATA[004];
	assign SW2 = DATA[005];
	assign SW1 = DATA[006];
	assign SW0 = DATA[007];
	//
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
module DATA_IN_VAR_RPI(
	input [11:0] ADC_U4,
	input [11:0] ADC_U8,
	input [11:0] ADC_U9,
	input QE_CW,
	input QE_CCW,	
	input [31:0] QE_COUNTER,
	input [31:0] QE_SPEED,
	input QES_CW,
	input QES_CCW,	
	input [31:0] QES_COUNTER,
	//
	input FPGA_TO_RPI_15,	
	input FPGA_TO_RPI_14,	
	input FPGA_TO_RPI_13,	
	input FPGA_TO_RPI_12,	
	input FPGA_TO_RPI_11,	
	input FPGA_TO_RPI_10,	
	input FPGA_TO_RPI_09,	
	input FPGA_TO_RPI_08,	
	input FPGA_TO_RPI_07,	
	input FPGA_TO_RPI_06,	
	input FPGA_TO_RPI_05,	
	input FPGA_TO_RPI_04,	
	input FPGA_TO_RPI_03,	
	input FPGA_TO_RPI_02,	
	input FPGA_TO_RPI_01,	
	input FPGA_TO_RPI_00,
	input [15:0] FPGA_TO_RPI_16BIT_1,
	input [15:0] FPGA_TO_RPI_16BIT_2,	
	input [15:0] FPGA_TO_RPI_16BIT_3,	
	input [15:0] FPGA_TO_RPI_16BIT_4,			
	//
	output [255:0] DATA
	);
	//
	assign DATA[015:004] = ADC_U4[11:0];
	assign DATA[031:020] = ADC_U8[11:0];
	assign DATA[047:036] = ADC_U9[11:0];
	assign DATA[052]     = QES_CW;
	assign DATA[053]     = QES_CCW;
	assign DATA[054]     = QE_CW;
	assign DATA[055]     = QE_CCW;
	assign DATA[087:056] = QE_COUNTER[31:0];
	assign DATA[119:088] = QE_SPEED[31:0];	
	assign DATA[151:120] = QES_COUNTER[31:0];	
	//
	assign DATA[176]     = FPGA_TO_RPI_15;
	assign DATA[177]     = FPGA_TO_RPI_14;
	assign DATA[178]     = FPGA_TO_RPI_13;
	assign DATA[179]     = FPGA_TO_RPI_12;
	assign DATA[180]     = FPGA_TO_RPI_11;
	assign DATA[181]     = FPGA_TO_RPI_10;
	assign DATA[182]     = FPGA_TO_RPI_09;
	assign DATA[183]     = FPGA_TO_RPI_08;	
	assign DATA[184]     = FPGA_TO_RPI_07;
	assign DATA[185]     = FPGA_TO_RPI_06;
	assign DATA[186]     = FPGA_TO_RPI_05;
	assign DATA[187]     = FPGA_TO_RPI_04;
	assign DATA[188]     = FPGA_TO_RPI_03;
	assign DATA[189]     = FPGA_TO_RPI_02;
	assign DATA[190]     = FPGA_TO_RPI_01;
	assign DATA[191]     = FPGA_TO_RPI_00;	
	//
	assign DATA[207:192] = FPGA_TO_RPI_16BIT_1[15:0];
	assign DATA[223:208] = FPGA_TO_RPI_16BIT_2[15:0];
	assign DATA[239:224] = FPGA_TO_RPI_16BIT_3[15:0];
	assign DATA[255:240] = FPGA_TO_RPI_16BIT_4[15:0];	
	//
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
module DATA_OUT_VAR_RPI(
	input [255:0] DATA,
	//
	output[11:0] DAC_U5,
	output DAC_U5_ADC_U8,
	output ANTRIEB_ENABLE,
	output ANTRIEB_CW,
	output ANTRIEB_CCW,	
	output [11:0] ANTRIEB_PWM,
	output QE_RESET,
	output QES_RESET,	
	output [11:0] ANTRIEB_ADC_LIMIT,
	output [7:0] D1_ROT,
	output [7:0] D1_GRUEN,
	output [7:0] D1_BLAU,	
	output [7:0] D2_ROT,
	output [7:0] D2_GRUEN,
	output [7:0] D2_BLAU,	
	output [7:0] D3_ROT,
	output [7:0] D3_GRUEN,
	output [7:0] D3_BLAU,
	//
	output RPI_TO_FPGA_15,
	output RPI_TO_FPGA_14,
	output RPI_TO_FPGA_13,
	output RPI_TO_FPGA_12,
	output RPI_TO_FPGA_11,
	output RPI_TO_FPGA_10,
	output RPI_TO_FPGA_09,
	output RPI_TO_FPGA_08,
	output RPI_TO_FPGA_07,
	output RPI_TO_FPGA_06,
	output RPI_TO_FPGA_05,
	output RPI_TO_FPGA_04,
	output RPI_TO_FPGA_03,
	output RPI_TO_FPGA_02,
	output RPI_TO_FPGA_01,
	output RPI_TO_FPGA_00,
	//
	output [15:0] RPI_TO_FPGA_16BIT_1,
	output [15:0] RPI_TO_FPGA_16BIT_2,
	output [15:0] RPI_TO_FPGA_16BIT_3,
	output [15:0] RPI_TO_FPGA_16BIT_4,
	//
	output WDT_ENABLE
	);
	//
	assign DAC_U5[11:0]            = DATA[015:004];
	assign DAC_U5_ADC_U8           = DATA[000];
	//
	assign ANTRIEB_ENABLE          = DATA[016];
	assign ANTRIEB_CW              = DATA[017];
	assign ANTRIEB_CCW             = DATA[018];	
	assign ANTRIEB_PWM[11:0]       = DATA[031:020];
	//
	assign QES_RESET               = DATA[038];
	assign QE_RESET                = DATA[039];
	//
	assign ANTRIEB_ADC_LIMIT[11:0] = DATA[055:044];
	//
	// RGB Leuchtdioden
	assign D1_ROT[7:0]   = DATA[063:056];
	assign D1_GRUEN[7:0] = DATA[071:064];
	assign D1_BLAU[7:0]  = DATA[079:072];
	assign D2_ROT[7:0]   = DATA[087:080];
	assign D2_GRUEN[7:0] = DATA[095:088];
	assign D2_BLAU[7:0]  = DATA[103:096];
	assign D3_ROT[7:0]   = DATA[111:104];
	assign D3_GRUEN[7:0] = DATA[119:112];
	assign D3_BLAU[7:0]  = DATA[127:120];	
	//
	assign WDT_ENABLE   = !DATA[175];
	//
	assign RPI_TO_FPGA_15            = DATA[176];
	assign RPI_TO_FPGA_14            = DATA[177];
	assign RPI_TO_FPGA_13            = DATA[178];
	assign RPI_TO_FPGA_12            = DATA[179];
	assign RPI_TO_FPGA_11            = DATA[180];
	assign RPI_TO_FPGA_10            = DATA[181];
	assign RPI_TO_FPGA_09            = DATA[182];
	assign RPI_TO_FPGA_08            = DATA[183];	
	assign RPI_TO_FPGA_07            = DATA[184];
	assign RPI_TO_FPGA_06            = DATA[185];
	assign RPI_TO_FPGA_05            = DATA[186];
	assign RPI_TO_FPGA_04            = DATA[187];
	assign RPI_TO_FPGA_03            = DATA[188];
	assign RPI_TO_FPGA_02            = DATA[189];
	assign RPI_TO_FPGA_01            = DATA[190];
	assign RPI_TO_FPGA_00            = DATA[191];	
	//
	assign RPI_TO_FPGA_16BIT_1[15:0] = DATA[207:192];	
	assign RPI_TO_FPGA_16BIT_2[15:0] = DATA[223:208];	
	assign RPI_TO_FPGA_16BIT_3[15:0] = DATA[239:224];	
	assign RPI_TO_FPGA_16BIT_4[15:0] = DATA[255:240];	
	//
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
