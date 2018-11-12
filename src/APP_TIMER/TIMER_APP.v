module TIMER_APP(
	input CLK,
	input CLK_1kHz,
	input CLK_100Hz,
	input CLK_10Hz,
	input CLK_1Hz,
	input USER_BUTTON,
	input SW7,
	input SW6,
	input SW5,
	input SW4,
	input SW3,
	input SW2,
	input SW1,
	input SW0,
	//
	output reg LED8,
	output reg LED7,
	output reg LED6,
	output reg LED5,
	output reg LED4,
	output reg LED3,
	output reg LED2,
	output reg LED1,
	output reg LED0,	
	//
	output wire [7:0] MIN_ZEHNER,
	output wire [7:0] MIN_EINER,
	output wire [7:0] SEK_ZEHNER,
	output wire [7:0] SEK_EINER,
	output wire [7:0] SEK_ZEHNTEL,
	output wire [7:0] SEK_HUNDERTSTEL,
	output wire [7:0] SEK_TAUSENDSTEL,	
	output reg [31:0] COUNTER
	);
	//	
	reg [1:0] state;
	reg [3:0] dec_min_zehner;
	reg [3:0] dec_min_einer;
	reg [3:0] dec_sek_zehner;
	reg [3:0] dec_sek_einer;
	reg [3:0] dec_sek_zehntel;
	reg [3:0] dec_sek_hundertstel;
	reg [3:0] dec_sek_tausendstel;
	reg [31:0] tausendstel;
	reg [31:0] sekunden;
	reg [31:0] minuten;
	
	//
	reg hri1; reg hri2; reg hri3; reg hri4; reg hri5; reg hri6;
	wire clk_1kHz_re; wire clk_1kHz_fe;
	wire clk_1Hz_re; wire clk_1Hz_fe;
	wire user_button_re; wire user_button_fe;
	//
	reg timer_enable;
	//
	assign clk_1kHz_re = (hri1 && !hri2);
	assign clk_1kHz_fe = (!hri1 && hri2);
	assign clk_1Hz_re = (hri3 && !hri4);
	assign clk_1Hz_fe = (!hri3 && hri4);
	assign user_button_re = (hri5 && !hri6);
	assign user_button_fe = (!hri5 && hri6);
	//
	HEX_SEG_7      hex_seg_7_min_zehner(CLK, dec_min_zehner,      1'b0, MIN_ZEHNER);
	HEX_SEG_7       hex_seg_7_min_einer(CLK, dec_min_einer,       1'b1, MIN_EINER);
	HEX_SEG_7      hex_seg_7_sek_zehner(CLK, dec_sek_zehner,      1'b0, SEK_ZEHNER);
	HEX_SEG_7       hex_seg_7_sek_einer(CLK, dec_sek_einer,       1'b1, SEK_EINER);
	HEX_SEG_7     hex_seg_7_sek_zehntel(CLK, dec_sek_zehntel,     1'b0, SEK_ZEHNTEL);
	HEX_SEG_7 hex_seg_7_sek_hundertstel(CLK, dec_sek_hundertstel, 1'b0, SEK_HUNDERTSTEL);
	HEX_SEG_7 hex_seg_7_sek_tausendstel(CLK, dec_sek_tausendstel, 1'b0, SEK_TAUSENDSTEL);
	//
	initial
	begin
		COUNTER <= 612345;
		LED0 <= 0; LED1 <= 0; LED2 <= 0; LED3 <= 0; LED4 <= 0; LED5 <= 0; LED6 <= 0; LED7 <= 0; LED8 <= 0;
		//
		state <= 2'd0;
		dec_min_zehner <= 0;
		dec_min_einer <= 0;
		dec_sek_zehner <= 0;
		dec_sek_einer <= 0;
		dec_sek_zehntel <= 0;
		dec_sek_hundertstel <= 0;
		dec_sek_tausendstel <= 0;
		tausendstel <= 0;
		sekunden <= 0;
		minuten <= 0;
		//
		hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0; hri5 <= 0; hri6 <= 0;
		timer_enable <= 0;
	end
	//
	always @(posedge CLK)
	begin
	//
	hri1 <= CLK_1kHz;
	hri2 <= hri1;
	hri3 <= CLK_1Hz;
	hri4 <= hri3;	
	hri5 <= USER_BUTTON;
	hri6 <= hri5;		
	//
	if (user_button_re) timer_enable <= 1;
	if (user_button_fe) timer_enable <= 0;
	// 
	if (timer_enable && clk_1kHz_re) 
		begin
		COUNTER <= COUNTER + 1;
		end
	//
	// COUNTER Reset
	if (!timer_enable && SW0) 
		begin
		COUNTER <= 0;
		end
	//
	LED0 <= USER_BUTTON;
	//
	// Umwandlung der Countervaiable in die 7-Segmentdarstellung
	if (state == 2'd0)
		begin
		tausendstel <= COUNTER % 1000;
		sekunden <= COUNTER / 1000;
		state <= state + 1;
		end
	//
	if (state == 2'd1)
		begin
		minuten <= sekunden / 60;
		sekunden <= sekunden % 60;
		//
		dec_sek_tausendstel <= tausendstel % 10;
		tausendstel <= tausendstel / 10;
		state <= state + 1;
		end
	//
	if (state == 2'd2)
		begin
		dec_min_einer <= minuten % 10;
		minuten <= minuten / 10;
		//
		dec_sek_einer <= sekunden % 10;
		sekunden <= sekunden / 10;
		//
		dec_sek_hundertstel <= tausendstel % 10;
		tausendstel <= tausendstel / 10;
		//
		state <= state + 1;
		end
	//
	if (state == 2'd3)
		begin
		dec_min_zehner <= minuten % 10;
		//
		dec_sek_zehner <= sekunden % 10;
		//
		dec_sek_zehntel <= tausendstel % 10;
		//
		state <= 2'd0;
		end
	//
	end
endmodule

/////////////////////////////////////////////////////////
module HEX_SEG_7 (
	input wire CLK,
	input wire [3:0] HEX,
	input wire DP,
	output reg [7:0] SEG7
	);
	//
	initial
	begin
		SEG7 <= 8'b00000000;
	end
	//
	always	@(posedge CLK) begin	
	// Transformation von HEX nach 7-Segmentanzeige
	case(HEX[3:0])     /*abcdefg.*/
		4'h0: SEG7[7:1] <= 7'b1111110;
		4'h1: SEG7[7:1] <= 7'b0110000;
		4'h2: SEG7[7:1] <= 7'b1101101;
		4'h3: SEG7[7:1] <= 7'b1111001;
		4'h4: SEG7[7:1] <= 7'b0110011;
		4'h5: SEG7[7:1] <= 7'b1011011;
		4'h6: SEG7[7:1] <= 7'b1011111;
		4'h7: SEG7[7:1] <= 7'b1110000;
		4'h8: SEG7[7:1] <= 7'b1111111;
		4'h9: SEG7[7:1] <= 7'b1111011;
		4'hA: SEG7[7:1] <= 7'b1110111;
		4'hb: SEG7[7:1] <= 7'b0011111;
		4'hC: SEG7[7:1] <= 7'b1001110;
		4'hd: SEG7[7:1] <= 7'b0111101;
		4'hE: SEG7[7:1] <= 7'b1001111;
		4'hF: SEG7[7:1] <= 7'b1000111;
		//default: SEG7 <= 8'b00000000;
	endcase
	//
	SEG7[0] <= DP;
	//
	end
endmodule