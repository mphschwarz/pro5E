`include "MODULDEMO.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg in_1bit;
	reg [7:0] in_8bit;
	wire out_1bit_wire;
	wire out_1bit_reg;
	wire [7:0] out_8bit_reg;
	//
	initial 
		begin
		clk <= 1;
		in_1bit <= 0;
		in_8bit <= 0;
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#3 begin
		   in_1bit <= 1;
		   in_8bit <= 8'hAA;
		   end
		//
		#4 begin
		   in_1bit <= 0;
		   in_8bit <= 8'hCC;
		   end
		//
		#4 in_8bit <= 8'hEE;
		//
		#10 $finish; 
		end 
	//
	always #1 clk <= !clk;// 50MHz
	//
	MODULDEMO moduldemo(clk, 
	                    in_1bit,
						in_8bit,
						out_1bit_wire,
						out_1bit_reg,
						out_8bit_reg);
	defparam moduldemo.VALUE_STATE_1 = 8'hFF;
	//
endmodule


/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_00_02\src\BASIS\VERILOG\GLUE_LOGIC
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/