////////////////////////////////////////////////////////////////////////////////////////////
module QUADRATUR_ENCODER(
	input CLK,
	input A,
	input B,
	input LATCH,
	input RESET,
	output reg signed [31:0] COUNTER,
	output reg signed [31:0] SPEED,
	output reg CW,
	output reg CCW
	);
	//
	reg signed [31:0] counter_temp;
	reg signed [31:0] speed_temp;
	reg hri1; reg hri2; reg hri3; reg hri4; reg hri5; reg hri6;
	//
	wire a_;
	wire b_;
	wire a_re;
	wire a_fe;
	wire b_re;
	wire b_fe;
	wire latch_re;
	//
	localparam ENC_FILTER = 5'd10;
	ENC_INP_FILTER enc_inp_filter_a(CLK, A, a_); defparam enc_inp_filter_a.FILTER = ENC_FILTER;
	ENC_INP_FILTER enc_inp_filter_b(CLK, B, b_); defparam enc_inp_filter_b.FILTER = ENC_FILTER;	
	//
	assign a_re = (hri1 && !hri2);
	assign a_fe = (!hri1 && hri2);	
	assign b_re = (hri3 && !hri4);
	assign b_fe = (!hri3 && hri4);
	assign latch_re = (hri5 && !hri6);	
	//
	initial
	begin	
		CW <= 0;
		CCW <= 0;
		COUNTER <= 0;
		SPEED <= 0;
		//
		counter_temp <= 0;
		speed_temp <= 0;
		//
		hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0; hri5 <= 0; hri6 <= 0;
	end
	//
	always @(posedge CLK)
	begin
	// Impulsauswertung
	hri1 <= a_;
	hri2 <= hri1;	
	//
	hri3 <= b_;
	hri4 <= hri3;	
	//
	hri5 <= LATCH;
	hri6 <= hri5;	
	//
	if ((a_re && !b_) || (b_re && a_) || (a_fe && b_) || (b_fe && !a_))
		begin
		counter_temp <= counter_temp + 1;
		CW <= 1;
		CCW <= 0;
		end
	//
	else if ((a_re && b_) || (b_fe && a_) || (a_fe && !b_) || (b_re && !a_))
		begin
		counter_temp <= counter_temp - 1;
		CW <= 0;
		CCW <= 1;
		end
	//
	//if (latch_re)
	//	begin
		COUNTER <= counter_temp;
	//	end
	//
	// Drehzahlerfassung mit Betrachtung des Ueberlaufes +-2^31
	if (CW && (speed_temp < 2147483640))
		begin
		speed_temp <= speed_temp + 1;
		end
	//
	if (CCW && (speed_temp > -2147483640))
		begin
		speed_temp <= speed_temp - 1;
		end
	//
	if (a_re || (speed_temp <= -50000000) || (speed_temp >= 50000000))
		begin
		SPEED <= speed_temp;
		speed_temp <= 0;
		end
	//	
	if (RESET)
		begin
		counter_temp <= 0;
		COUNTER <= 0;
		speed_temp <= 0;
		SPEED <= 0;
		end
	end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
//	Digitales Filter
module	ENC_INP_FILTER (
	input CLK, 
	input IN,
	output reg OUT
	);
//
parameter FILTER = 5'd5;
//
reg [4:0] ctr0;
reg [4:0] ctr1;
//
initial
	begin
	OUT <= 0;
	ctr0 <= 0;
	ctr1 <= 0;
	end
always	@(posedge CLK)
begin
	if (IN && !OUT)
		begin
		ctr0 <= 0;
		ctr1 <= ctr1 + 1;
		end
	//	
	if (!IN && OUT)
		begin
		ctr0 <= ctr0 + 1;
		ctr1 <= 0;
		end	
	//
	if (ctr0 == FILTER)
		begin
		ctr0 <= 0;
		ctr1 <= 0;
		OUT <= 0;
		end
	//
	if (ctr1 == FILTER)
		begin
		ctr0 <= 0;
		ctr1 <= 0;
		OUT <= 1;
		end
	//	
	if (((ctr0 > 0) && IN) || ((ctr1 > 0) && !IN))
		begin
		ctr0 <= 0;
		ctr1 <= 0;
		end	
end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////

