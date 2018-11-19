`include "TEST.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg clk_1MHz;
	reg clk_1Hz;
	reg in8;
	reg in9;
	reg in10;
	reg in11;
	reg in12;
	reg in13;
	reg in14;
	reg in15;
	reg [15:0] in16bit1;
	reg [15:0] in16bit2;
	reg [15:0] in16bit3;
	reg [15:0] in16bit4;	
	//
	wire out8;
	wire out9;
	wire out10;
	wire out11;	
	wire out12;
	wire out13;
	wire out14;
	wire out15;	
	wire [15:0] out16bit1;
	wire [15:0] out16bit2;
	wire [15:0] out16bit3;
	wire [15:0] out16bit4;		
	//
	initial 
		begin
		clk <= 1;
		clk_1MHz <= 1;
		clk_1Hz <= 1;
		in8 <= 0;
		in9 <= 0;
		in10 <= 0;
		in11 <= 0;
		in12 <= 0;
		in13 <= 0;
		in14 <= 0;
		in15 <= 0;
		in16bit1 <= 0;
		in16bit2 <= 0;
		in16bit3 <= 0;
		in16bit4 <= 0;
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#10 in8 <= 1;
		#10 in8 <= 0;
		#10 in8 <= 1;
		#10 in8 <= 0;
		#10 in8 <= 1;
		#10 in8 <= 0;
		#10 in8 <= 1;
		#10 in8 <= 0;
		#10 in8 <= 1;
		#10 in8 <= 0;
		#10 in9 <= 1;
		#10 in9 <= 0;
		#10 in9 <= 1;
		#10 in9 <= 0;
		#10 in10 <= 1;
		#10 in10 <= 0;
		//
		#10 $finish; 
		end 
	//
	always #1        clk <= !clk;// 50MHz
	always #50       clk_1MHz <= !clk_1MHz;// 1MHz	
	always #50000000 clk_1Hz <= !clk_1Hz;// 1Hz		
	//
	TEST test(clk,
			  clk_1MHz,
			  clk_1Hz,
			  in8,
			  in9,
			  in10,
			  in11,
			  in12,
			  in13,
			  in14,
			  in15,
			  in16bit1,
			  in16bit2,
			  in16bit3,
			  in16bit4,
			  out8,
			  out9,
			  out10,
			  out11,
			  out12,
			  out13,
			  out14,
			  out15,
			  out16bit1,
			  out16bit2,
			  out16bit3,
			  out16bit4);					
	//
endmodule
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_01_00\src\BASIS\VERILOG\TEST
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/