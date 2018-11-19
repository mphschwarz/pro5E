`include "FLANKENTRIGGER.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg clk_1MHz;
	reg signal;
	wire re;
	wire fe;
	wire [7:0] counter;
	//
	initial 
		begin
		clk <= 1;
		signal <= 0;
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#10 signal <= 1;
		#10 signal <= 0;
		#10 signal <= 1;
		#10 signal <= 0;
		//
		#10 $finish; 
		end 
	//
	always #1 clk <= !clk;// 50MHz
	//
	FLANKENTRIGGER flankentrigger(clk, signal, re, fe, counter);					
	//
endmodule


/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_00_02\src\BASIS\VERILOG\GLUE_LOGIC
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/