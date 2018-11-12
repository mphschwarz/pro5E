`include "TIMER_APP.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg clk_1kHz;
	reg clk_100Hz;
	reg clk_10Hz;
	reg clk_1Hz;
	reg user_button;
	reg sw7;
	reg sw6;
	reg sw5;
	reg sw4;
	reg sw3;
	reg sw2;
	reg sw1;
	reg sw0;
	wire led8;
	wire led7;
	wire led6;
	wire led5;
	wire led4;
	wire led3;
	wire led2;
	wire led1;
	wire led0;
	output wire [7:0] min_zehner;
	output wire [7:0] min_einer;
	output wire [7:0] sek_zehner;
	output wire [7:0] sek_einer;
	output wire [7:0] sek_zehntel;
	output wire [7:0] sek_hundertstel;
	output wire [7:0] sek_tausendstel;
	output wire [31:0] counter;	
	//
	initial 
	begin
		clk <= 1;
		clk_1kHz <= 1;
		clk_100Hz <= 1;
		clk_10Hz <= 1;
		clk_1Hz <= 1;
		user_button <= 0;
		sw7 <= 0;
		sw6 <= 0;
		sw5 <= 0;
		sw4 <= 0;
		sw3 <= 0;
		sw2 <= 0;
		sw1 <= 0;
		sw0 <= 0;
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#150 user_button <= 1;
		#10000 user_button <= 0;
		//
		#10000 $finish; 
	end 
	//
	always #1        clk <= !clk;// 50MHz
	// Skalierung um den Faktor 1000
	always #50       clk_1kHz <= !clk_1kHz;// 1kHz => 50000
	always #500      clk_100Hz <= !clk_100Hz;// 100Hz => 500000	
	always #5000     clk_10Hz <= !clk_10Hz;// 10Hz	=> 5000000
	always #50000    clk_1Hz <= !clk_1Hz;// 1Hz	=> 50000000
	//
	TIMER_APP timer_app(clk,
						clk_1kHz,
						clk_100Hz,
						clk_10Hz,
						clk_1Hz,
						user_button,
						sw7,
						sw6,
						sw5,
						sw4,
						sw3,
						sw2,
						sw1,
						sw0,
						led8,
						led7,
						led6,
						led5,
						led4,
						led3,
						led2,
						led1,
						led0,
						min_zehner,
						min_einer,
						sek_zehner,
						sek_einer,
						sek_zehntel,
						sek_hundertstel,
						sek_tausendstel,
						counter
						);				
	//
endmodule
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_01_00\src\APP_TIMER
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/