// https://de.wikipedia.org/wiki/Glue_Logic
module GLUE_LOGIC(
	input CLK,
	input CLK_1MHz,
	input CLK_1Hz,
	input IN4,
	input IN5,
	input IN6,
	input IN7,
	output wire OUT4,
	output wire OUT5,
	output wire OUT6, 
	output wire OUT7
	);
	//
	assign OUT4 = (IN4 && IN5) || !IN6;
	assign OUT5 = IN5;
	assign OUT6 = IN6;	
	assign OUT7 = 1;		
	//
endmodule