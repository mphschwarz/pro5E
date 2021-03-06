module TEST(
	input CLK,
	input CLK_1MHz,
	input CLK_1Hz,
	input IN8,
	input IN9,
	input IN10,
	input IN11,
	input IN12,
	input IN13,
	input IN14,
	input IN15,
	input [15:0] IN16BIT1,
	input [15:0] IN16BIT2,
	input [15:0] IN16BIT3,
	input signed [15:0] IN16BIT4,	
	//
	output reg OUT8,
	output reg OUT9,
	output reg OUT10, 
	output reg OUT11,
	output reg OUT12,
	output reg OUT13,
	output reg OUT14, 
	output reg OUT15,
	output reg [15:0] OUT16BIT1,
	output reg [15:0] OUT16BIT2,
	output reg [15:0] OUT16BIT3,
	output reg signed [15:0] OUT16BIT4);
	//
	initial
	begin
		OUT16BIT1 <= 0;
		OUT16BIT2 <= 0;
		OUT16BIT3 <= 0;
		OUT16BIT4 <= 0;
		OUT8 <= 0; OUT9 <= 0; OUT10 <= 0; OUT11 <= 0; OUT12 <= 0; OUT13 <= 0; OUT14 <= 0; OUT15 <= 0;
	end
	//
	always @(posedge CLK)
	begin
		OUT8 <= IN8;
		OUT9 <= IN9;
		OUT10 <= IN10;
		OUT11 <= IN11;
		OUT12 <= IN12;
		OUT13 <= IN13;
		OUT14 <= IN14;
		OUT15 <= IN15;
		//
		OUT16BIT1 <= IN16BIT1;
		OUT16BIT2 <= IN16BIT2;
		OUT16BIT3 <= IN16BIT3;
		OUT16BIT4 <= IN16BIT4;
		//
	end
endmodule