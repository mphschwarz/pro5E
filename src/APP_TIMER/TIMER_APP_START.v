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
	reg [3:0] state;
	reg [3:0] dec_min_zehner;
	reg [3:0] dec_min_einer;
	reg [3:0] dec_sek_zehner;
	reg [3:0] dec_sek_einer;
	reg [3:0] dec_sek_zehntel;
	reg [3:0] dec_sek_hundertstel;
	reg [3:0] dec_sek_tausendstel;
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
		COUNTER <= 0;
		LED0 <= 0; LED1 <= 0; LED2 <= 0; LED3 <= 0; LED4 <= 0; LED5 <= 0; LED6 <= 0; LED7 <= 0; LED8 <= 0;
		//
		state <= 0;
		dec_min_zehner <= 0;
		dec_min_einer <= 0;
		dec_sek_zehner <= 0;
		dec_sek_einer <= 0;
		dec_sek_zehntel <= 0;
		dec_sek_hundertstel <= 0;
		dec_sek_tausendstel <= 0;
	end
	//
	always @(posedge CLK)
	begin
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
	//
	end
endmodule