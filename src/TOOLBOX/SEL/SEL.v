////////////////////////////////////////////////////////////////////////////////////////////
module SEL_SPI_INPUT(
	input CLK,
	input CLK_1kHz,
	input SEL,
	input CS0,
	input CLK0,
	input MOSI0,
	input CS1,
	input CLK1,
	input MOSI1,	
	output reg SEL_AKTIV,
	output reg CS_OUT,
	output reg CLK_OUT,
	output reg MOSI_OUT);
	//
	parameter DELAY_TIME = 16'd100;
	//
	reg [15:0] counter;
	reg [0:0] status;
	//
	reg hri1; reg hri2;
	//
	wire 	imp1kHz;
	//wire 	imp1Hz_n;
	//
	assign	imp1kHz = (hri1 && !hri2);
	//assign	imp1kHz_n = (!hri1 && hri2);
	//
	initial
	begin
		CS_OUT <= 0;
		CLK_OUT <= 0;
		MOSI_OUT <= 0;
		SEL_AKTIV <= 0;
		//
		counter <= 0;
		status <= 0;
		//
		hri1 <= 0; hri2 <= 0;
	end
	//
	always @(posedge CLK)
	begin	
	//
	hri1 <= CLK_1kHz;
	hri2 <= hri1;	
	//
	if (imp1kHz) counter <= counter + 1;
	//
	if (SEL || (counter >= DELAY_TIME))
		begin
		counter <= 1;
		if(SEL) status <= 1;
		else status <= 0;
		end	
	//
	if (SEL_AKTIV)
		begin
		CS_OUT <= CS1;
		CLK_OUT <= CLK1;
		MOSI_OUT <= MOSI1;
		end		
	else
		begin
		CS_OUT <= CS0;
		CLK_OUT <= CLK0;
		MOSI_OUT <= MOSI0;
		end				
	//
	if (status == 0) 
		begin
		SEL_AKTIV <= 0;
		end
	//
	if (status == 1)
		begin
		SEL_AKTIV <= 1;
		end
	//	
	end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
module SEL_1_BIT(
	input SEL,
	input IN0,
	input IN1,
	output wire OUT);
	//
	assign OUT = (IN0 && !SEL) || (IN1 && SEL);
	//
endmodule
////////////////////////////////////////////////////////////////////////////////////////////

module SEL_12_BIT(
	input CLK,
	input SEL,
	input [11:0] IN0,
	input [11:0] IN1,
	output reg [11:0] OUT);
	//
	initial
		begin
			OUT <= 0;
		end
	//
	always @(posedge CLK)
	begin	
		if (SEL) OUT <= IN1;
		else OUT <= IN0;
	end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////