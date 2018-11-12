module IO16_VERILOG(
	input CLK,
	input CLK_1MHz,
	input CLK_1Hz,
	input S1,
	input S2,
	input S3,
	input S4,
	input S5,
	input S6,
	input S7,
	input S8,
	input S9,
	input S10,
	input S11,
	input S12,
	input S13,
	input S14,
	input S15,
	input S16,
	//
	output reg D1,
	output reg D2,
	output reg D3, 
	output reg D4,
	output reg D5,
	output reg D6,
	output reg D7, 
	output reg D8,
	output reg D9,
	output reg D10,
	output reg D11, 
	output reg D12,
	output reg D13,
	output reg D14,
	output reg D15, 
	output reg D16	
	);
	//
	reg [7:0] counter;
	wire S9re; wire s9fe;
	wire S10re; wire s10fe;
	reg hri1; reg hri2; reg hri3; reg hri4;
	//
	assign S9re = (hri1 && !hri2);
	assign s9fe = (!hri1 && hri2);
	assign S10re = (hri3 && !hri4);
	assign s10fe = (!hri3 && hri4);	
	//
	initial
	begin
		D1 <= 0; D2 <= 0;  D3 <= 0;  D4 <= 0;  D5 <= 0;  D6 <= 0;  D7 <= 0;  D8 <= 0;
		D9 <= 0; D10 <= 0; D11 <= 0; D12 <= 0; D13 <= 0; D14 <= 0; D15 <= 0; D16 <= 0;
		//
		counter <= 0;
		hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0;
	end
	//
	always @(posedge CLK)
	begin
		//
		// Flankenauswertung
		hri1 <= S9;
		hri2 <= hri1;	
		hri3 <= S10;
		hri4 <= hri3;	
		//
		if (S9re) counter <= counter + 1;
		if (S10re) counter <= counter - 1;
		if (S11) counter <= 0;
		//
		// Ausgabe des Counterwertes auf die Dioden D1-D8
		D1 <= counter[7];
		D2 <= counter[6];
		D3 <= counter[5];
		D4 <= counter[4];
		D5 <= counter[3];
		D6 <= counter[2];
		D7 <= counter[1];
		D8 <= counter[0];
		//
		D9 <= S9;
		D10 <= S10;
		D11 <= S11;
	end
endmodule