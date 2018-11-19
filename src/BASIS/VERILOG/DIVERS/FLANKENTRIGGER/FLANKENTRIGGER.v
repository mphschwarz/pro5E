module FLANKENTRIGGER(
	input CLK,
	input SIGNAL,
	output RE,
	output FE,
	output reg [7:0] COUNTER);
	//	
	reg hri1; 
	reg hri2;
	//
	assign RE = (hri1 && !hri2);
	assign FE = (!hri1 && hri2);
	//
	initial
	begin
		COUNTER <= 0;
		hri1 <= 0; 
		hri2 <= 0;
	end
	//
	always @(posedge CLK)
	begin
	//
	hri1 <= SIGNAL;
	hri2 <= hri1;	
	//
	if (RE) 
		begin
		COUNTER <= COUNTER + 1;
		end
	//
	end
endmodule