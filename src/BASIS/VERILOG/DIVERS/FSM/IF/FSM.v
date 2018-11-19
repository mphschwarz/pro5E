module FSM(
	input CLK,
	input START,
	output reg OUT_SIG_1,
	output reg OUT_SIG_2);
	//	
	localparam INIT = 3'd0;
	localparam WARTE_START = 3'd1;
	localparam OUT_1 = 3'd2;
	localparam OUT_2 = 3'd3;
	//
	reg [2:0] state;
	//
	initial
	begin
		OUT_SIG_1 <= 0;
		OUT_SIG_2 <= 0;
		state <= INIT;
	end
	//
	always @(posedge CLK)
	begin
	if (state == INIT) // 3'd0
		begin  
		OUT_SIG_1 <= 0;
		OUT_SIG_2 <= 0;
		state <= WARTE_START;
		end
	//
	if (state == WARTE_START) // 3'd1
		if (START) state <= OUT_1;
	//
	if (state == OUT_1) // 3'd2
		begin
		OUT_SIG_1 <= 1;
		state <= OUT_2;
		end
	//
	if (state == OUT_2) // 3'd2
		begin
		OUT_SIG_2 <= 1;
		state <= INIT;
		end
	//
	if (state > OUT_2) // default
		state <= INIT;
	//
	end
endmodule