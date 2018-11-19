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
	reg [7:0] counter;
	wire IN8re; wire IN8fe;
	wire IN9re; wire IN9fe;
	reg hri1; reg hri2; reg hri3; reg hri4;
	//
	assign IN8re = (hri1 && !hri2);
	assign IN8fe = (!hri1 && hri2);
	assign IN9re = (hri3 && !hri4);
	assign IN9fe = (!hri3 && hri4);	
	//
	initial
	begin
		OUT16BIT1 <= 0;
		OUT16BIT2 <= 0;
		OUT16BIT3 <= 0;
		OUT16BIT4 <= 0;
		OUT8 <= 0; OUT9 <= 0; OUT10 <= 0; OUT11 <= 0; OUT12 <= 0; OUT13 <= 0; OUT14 <= 0; OUT15 <= 0;
		//
		counter <= 0;
		hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0;
	end
	//
	always @(posedge CLK)
	begin
		//
		// Flankenauswertung
		hri1 <= IN8;
		hri2 <= hri1;	
		hri3 <= IN9;
		hri4 <= hri3;	
		//
		if (IN8re) counter <= counter + 1;
		if (IN9re) counter <= counter - 1;
		if (IN10) counter <= 0;
		//
		OUT16BIT1[7:0] <= counter[7:0];
		//
	end
endmodule