module QUADRATUR_ENCODER_SIMPLE(
	input CLK,
	input A,
	input B,
	input RESET,
	output reg signed [31:0] COUNTER,
	output reg CW,
	output reg CCW
	);
	//
	reg hri1; reg hri2; reg hri3; reg hri4;
	//
	wire Are;
	wire Afe;
	wire Bre;
	wire Bfe;	
	//
	//
	assign Are = (hri1 && !hri2);
	assign Afe = (!hri1 && hri2);	
	assign Bre = (hri3 && !hri4);
	assign Bfe = (!hri3 && hri4);
	//
	initial
	begin	
		CW <= 0;
		CCW <= 0;
		COUNTER <= 0;
		//
		hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0;
	end
	//
	always @(posedge CLK)
	begin
	// Impulsauswertung
	hri1 <= A;
	hri2 <= hri1;	
	//
	hri3 <= B;
	hri4 <= hri3;		
	//
	if ((Are && !B) || (Bre && A) || (Afe && B) || (Bfe && !A))
		begin
		COUNTER <= COUNTER + 1;
		CW <= 1;
		CCW <= 0;
		end
	//
	else if ((Are && B) || (Bfe && A) || (Afe && !B) || (Bre && !A))
		begin
		COUNTER <= COUNTER - 1;
		CW <= 0;
		CCW <= 1;
		end
	//	
	if (RESET)
		begin
		COUNTER <= 0;
		COUNTER <= 0;
		end
	end
endmodule