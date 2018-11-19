module EINFUEHRUNG(
	input CLK,
	input CLK_1MHz,
	input CLK_1Hz,
	input IN1,
	input IN2,
	input IN3,
	input IN4,
	input IN5,
	input IN6,
	input IN7,
	input IN8,
	input [15:0] IN16BIT1,
	input [15:0] IN16BIT2,
	input [15:0] IN16BIT3,
	input [15:0] IN16BIT4,	
	//
	output reg OUT1,
	output reg OUT2,
	output reg OUT3, 
	output reg OUT4,
	output reg OUT5,
	output reg OUT6,
	output reg OUT7, 
	output reg OUT8,
	output reg [15:0] OUT16BIT1,
	output reg [15:0] OUT16BIT2,
	output reg [15:0] OUT16BIT3,
	output reg [15:0] OUT16BIT4);
	//
	initial
		begin
			OUT1 <= 0; OUT2 <= 0; OUT3 <= 0; OUT4 <= 0; OUT5 <= 0; OUT6 <= 0; OUT7 <= 0; OUT8 <= 0;
		end
	//
	always @(posedge CLK)
	begin
		OUT1 <= IN1;
		OUT2 <= IN2;
		OUT3 <= IN3;
		OUT4 <= IN4;
		OUT5 <= IN5;
		OUT6 <= IN6;
		OUT7 <= IN7;
		OUT8 <= IN8;
		//
		OUT16BIT1 <= IN16BIT1;
		OUT16BIT2 <= IN16BIT2;
		OUT16BIT3 <= IN16BIT3;
		OUT16BIT4 <= IN16BIT4;
		//
	end
endmodule