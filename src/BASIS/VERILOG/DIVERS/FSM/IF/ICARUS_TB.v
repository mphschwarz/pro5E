`include "FSM.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg start;
	wire out_sig_1;
	wire out_sig_2;
	//
	initial 
		begin
		clk <= 1;
		start <= 0;
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#7 start <= 1;
		#2 start <= 0;
		//
		#10 $finish; 
		end 
	//
	always #1 clk <= !clk;// 50MHz
	//
	FSM fsm(clk, start, out_sig_1, out_sig_2);
	//
endmodule


/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_00_02\src\BASIS\VERILOG\GLUE_LOGIC
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/