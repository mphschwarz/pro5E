///////////////////////////////////////////////////////////////
module DATA_IN_VAR_RPI_DEMO(
	input [11:0] ADC_U8,
	//
	input FPGA_TO_RPI_0,	
	input FPGA_TO_RPI_1,	
	input FPGA_TO_RPI_2,	
	input FPGA_TO_RPI_3,	
	input FPGA_TO_RPI_4,	
	input FPGA_TO_RPI_5,	
	input FPGA_TO_RPI_6,	
	input FPGA_TO_RPI_7,	
	input [15:0] FPGA_TO_RPI_16BIT_1,
	input [15:0] FPGA_TO_RPI_16BIT_2,	
	input [15:0] FPGA_TO_RPI_16BIT_3,	
	input [15:0] FPGA_TO_RPI_16BIT_4,			
	//
	output [255:0] DATA
	);
	//
	assign DATA[015:004] = ADC_U8[11:0];// MSB left
	//
	assign DATA[016]     = FPGA_TO_RPI_7;
	assign DATA[017]     = FPGA_TO_RPI_6;
	assign DATA[018]     = FPGA_TO_RPI_5;
	assign DATA[019]     = FPGA_TO_RPI_4;
	assign DATA[020]     = FPGA_TO_RPI_3;
	assign DATA[021]     = FPGA_TO_RPI_2;
	assign DATA[022]     = FPGA_TO_RPI_1;
	assign DATA[023]     = FPGA_TO_RPI_0;	
	//
	assign DATA[039:024] = FPGA_TO_RPI_16BIT_1[15:0];
	assign DATA[055:040] = FPGA_TO_RPI_16BIT_2[15:0];
	assign DATA[071:056] = FPGA_TO_RPI_16BIT_3[15:0];
	assign DATA[091:072] = FPGA_TO_RPI_16BIT_4[15:0];	
	//
endmodule
///////////////////////////////////////////////////////////////
module DATA_OUT_VAR_RPI_DEMO(
	input [255:0] DATA,
	//
	output[11:0] DAC_U5,
	//
	output RPI_TO_FPGA_0,
	output RPI_TO_FPGA_1,
	output RPI_TO_FPGA_2,
	output RPI_TO_FPGA_3,
	output RPI_TO_FPGA_4,
	output RPI_TO_FPGA_5,
	output RPI_TO_FPGA_6,
	output RPI_TO_FPGA_7,
	//
	output [15:0] RPI_TO_FPGA_16BIT_1,
	output [15:0] RPI_TO_FPGA_16BIT_2,
	output [15:0] RPI_TO_FPGA_16BIT_3,
	output [15:0] RPI_TO_FPGA_16BIT_4
	);
	//
	assign DAC_U5[11:0]              = DATA[015:004];
	//
	assign RPI_TO_FPGA_7             = DATA[016];
	assign RPI_TO_FPGA_6             = DATA[017];
	assign RPI_TO_FPGA_5             = DATA[018];
	assign RPI_TO_FPGA_4             = DATA[019];
	assign RPI_TO_FPGA_3             = DATA[020];
	assign RPI_TO_FPGA_2             = DATA[021];
	assign RPI_TO_FPGA_1             = DATA[022];
	assign RPI_TO_FPGA_0             = DATA[023];	
	//
	assign RPI_TO_FPGA_16BIT_1[15:0] = DATA[039:024];	
	assign RPI_TO_FPGA_16BIT_2[15:0] = DATA[055:040];	
	assign RPI_TO_FPGA_16BIT_3[15:0] = DATA[071:056];	
	assign RPI_TO_FPGA_16BIT_4[15:0] = DATA[091:072];	
	//
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
