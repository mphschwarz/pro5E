`include "DAC_MCP4921.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	//
	integer file;
	reg clk;
	reg latch;
	reg [11:0] value;
	wire cs_dac;
	wire clk_dac;
	wire sdo_dac;
	wire ldac_dac;	
	//
	initial 
	begin
		clk <= 1;
		latch <= 0;
		value <= 12'hA21;
		//
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 
		//
		#50 latch <= 1;
		#50 latch <= 0;
		//
		#2500 $finish; 
	end 
	//
	always #1 clk <= !clk;
	//
	DAC_MCP4921 dac_mcp4921(
					clk,
	                latch,
					value,
			        cs_dac,
			        clk_dac,
			        sdo_dac,
			        ldac_dac
					);
	//
endmodule
//
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA\FPGA_MODUL_MAX1000_00_21\src\DC_MOTOR
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/