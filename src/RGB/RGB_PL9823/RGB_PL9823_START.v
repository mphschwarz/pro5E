module RGB_PL9823( 
	input CLK,
	input [7:0] D1_ROT,
	input [7:0] D1_GRUEN,
	input [7:0] D1_BLAU,	
	input [7:0] D2_ROT,
	input [7:0] D2_GRUEN,
	input [7:0] D2_BLAU,	
	input [7:0] D3_ROT,
	input [7:0] D3_GRUEN,
	input [7:0] D3_BLAU,		
	output reg OUT
	);
	//
	reg [0:72] data;
	reg [7:0] i;
	reg [11:0] ctr;
	reg state;
	//
	initial
	begin
		OUT <= 0;
		//
		data <= 0;
		i <= 0;
		ctr <= 1;
		state <= 0;
	end
	//
	always @(posedge CLK) /* 50MHz => 20ns */
	begin
	if (state == 0) 
		begin
		ctr <= ctr + 1;
		OUT <= 0;
		//
		if (ctr == 3000) /* 3000 * 20ns = 60000ns */
			begin
			state <= 1;
			ctr <= 1;
			i <= 0;
			end
		end
	//
	if (state == 1) 
		begin
		if (i == 72) 
			begin
			state <= 0;
			ctr <= 1;
			i <= 0;
			end
		//
		ctr <= ctr + 1;
		if (ctr == 86) /* 86 * 20ns = 1720ns */
			begin
			ctr <= 1;
			i <= i + 1;
			end	
		//
		if (i < 72)
			begin
			if (ctr <= 18) /* 18 * 20ns = 360ns */
					OUT <= 1;
				else
					OUT <= 0;
			end
		end
	//
	end
endmodule