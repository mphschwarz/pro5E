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
	localparam TRANSFER = 1'd0;
	localparam AUSGABE = 1'd1;	
	//
	initial
	begin
		OUT <= 0;
		//
		data <= 0;
		i <= 0;
		ctr <= 1;
		state <= TRANSFER;
	end
	//
	always @(posedge CLK) /* 50MHz => 20ns */
	begin
	if (state == TRANSFER) 
		begin
		ctr <= ctr + 1;
		OUT <= 0;
		//				
		data[00:07] <= D1_ROT[7:0];
		data[08:15] <= D1_GRUEN[7:0];
		data[16:23] <= D1_BLAU[7:0];	
		//
		data[24:31] <= D2_ROT[7:0];
		data[32:39] <= D2_GRUEN[7:0];
		data[40:47] <= D2_BLAU[7:0];
		//
		data[48:55] <= D3_ROT[7:0];
		data[56:63] <= D3_GRUEN[7:0];
		data[64:71] <= D3_BLAU[7:0];
		//
		data[72] <= 0;
		//
		if (ctr == 3000) /* 3000 * 20ns = 60000ns */
			begin
			state <= AUSGABE;
			ctr <= 1;
			i <= 0;
			end
		end
	//
	if (state == AUSGABE) 
		begin
		if (i == 72) 
			begin
			state <= TRANSFER;
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
			if (data[i] == 1) 
				begin
				//
				if (ctr <= 68) /* 68 * 20ns = 1360ns */
					OUT <= 1;
				else
					OUT <= 0;
				//
				end
			else
				begin
				//
				if (ctr <= 18) /* 18 * 20ns = 360ns */
					OUT <= 1;
				else
					OUT <= 0;
				//
				end
			end
		end
	//
	end
endmodule