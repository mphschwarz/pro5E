module MODULDEMO(
	input CLK,
	input IN_1BIT,
	input [7:0] IN_8BIT,
	output OUT_1BIT_WIRE,
	output reg OUT_1BIT_REG,
	output reg [7:0] OUT_8BIT_REG);
	//	
	parameter VALUE_STATE_1 = 8'h11;
	//
	reg state;
	//
	assign OUT_1BIT_WIRE = IN_1BIT || OUT_8BIT_REG[0];
	//
	initial
	begin
		OUT_1BIT_REG <= 0;
		OUT_8BIT_REG <= 0;
		state <= 0;
	end
	//
	always @(posedge CLK)
	begin
	//
	state <= !state;
	//
	OUT_1BIT_REG <= IN_1BIT;
	//
	if (state == 0) 
		begin
		OUT_8BIT_REG <= VALUE_STATE_1;
		end
	//
	if (state == 1) 
		begin
		OUT_8BIT_REG <= IN_8BIT;
		end
	//
	end
endmodule