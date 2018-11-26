module DEMO(
	input CLK,
	input CLK_1MHz,
	input CLK_100kHz,
	input CLK_10Hz,
	input CLK_1Hz,
	input IN0,
	input IN1,
	input IN2,
	input IN3,
	input IN4,
	input IN5,
	input IN6,
	input IN7,
	input [15:0] IN16BIT1,
	input [15:0] IN16BIT2,
	input [15:0] IN16BIT3,
	input signed [15:0] IN16BIT4,	
	//
	output reg OUT0,
	output reg OUT1,
	output reg OUT2, 
	output reg OUT3,
	output reg OUT4,
	output reg OUT5,
	output reg OUT6, 
	output reg OUT7,
	output reg [15:0] OUT16BIT1,
	output reg [15:0] OUT16BIT2,
	output reg [15:0] OUT16BIT3,
	output reg signed [15:0] OUT16BIT4);
	//
	reg hri1; 
	reg hri2;
	wire re_100kHz;
	wire fe_100kHz;
	//
	// Flankenauswerteung
	assign re_100kHz = (hri1 && !hri2);
	assign fe_100kHz = (!hri1 && hri2);
	//
	initial
	begin
		OUT16BIT1 <= 0;
		OUT16BIT2 <= 0;
		OUT16BIT3 <= 0;
		OUT16BIT4 <= 0;
		OUT0 <= 0; OUT1 <= 0; OUT2 <= 0; OUT3 <= 0; OUT4 <= 0; OUT5 <= 0; OUT6 <= 0; OUT7 <= 0;
	end
	//
	always @(posedge CLK)
	begin
		hri1 <= CLK_100kHz;
		hri2 <= hri1;	
		//
		OUT0 <= IN0;
		OUT1 <= IN1;
		OUT2 <= IN2;
		OUT3 <= IN3;
		OUT4 <= IN4;
		OUT5 <= CLK_1Hz;
		OUT6 <= IN6 && IN7;
		OUT7 <= IN6 || IN7;
		//
		OUT16BIT1 <= IN16BIT1;
		OUT16BIT2 <= IN16BIT2;
		OUT16BIT3 <= IN16BIT3 + IN16BIT4;
		//
		if (re_100kHz)
		begin
			OUT16BIT4 <= OUT16BIT4 + 1;
		end
	end
endmodule
