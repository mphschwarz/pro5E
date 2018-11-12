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
	initial
		begin
			D1 <= 0; D2 <= 0;  D3 <= 0;  D4 <= 0;  D5 <= 0;  D6 <= 0;  D7 <= 0;  D8 <= 0;
			D9 <= 0; D10 <= 0; D11 <= 0; D12 <= 0; D13 <= 0; D14 <= 0; D15 <= 0; D16 <= 0;
		end
	//
	always @(posedge CLK)
	begin
		D1 <= S1;
		D2 <= S2;
		D3 <= S3;
		D4 <= S4;
		D5 <= S5;
		D6 <= S6;
		D7 <= S7;
		D8 <= S8;
		D9 <= S9;
		D10 <= S10;
		D11 <= S11;
		D12 <= S12;
		D13 <= S13;
		D14 <= S14;
		D15 <= S15;
		D16 <= S16;		
	end
endmodule