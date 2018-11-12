`include "ADC_MCP3201.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	//
	integer file;
	reg clk;
	reg latch;
	reg sdi_adc;
	wire cs_adc;
	wire clk_adc;
	wire [11:0] value;
	//
	initial 
	begin
		clk <= 1;
		latch <= 0;
		sdi_adc <= 0;
		//
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 
		//
		#50   latch <= 1;
		#50   latch <= 0;
		#152  latch <= 0;
		//
		#100  sdi_adc <= 0;// B11
		#100  sdi_adc <= 0;// B10
		#100  sdi_adc <= 0;// B9
		#100  sdi_adc <= 0;// B8
		#100  sdi_adc <= 1;// B7
		#100  sdi_adc <= 0;// B6
		#100  sdi_adc <= 0;// B5
		#100  sdi_adc <= 0;// B4
		#100  sdi_adc <= 0;// B3
		#100  sdi_adc <= 0;// B2
		#100  sdi_adc <= 0;// B1
		#100  sdi_adc <= 1;// B0
		//
		#100  sdi_adc <= 0;// HI-Z
		//
		#200 $finish; 
	end 
	//
	always #1 clk <= !clk;// 50MHz
	//
	ADC_MCP3201 adc_mcp3201(
					clk,
	                latch,
			        sdi_adc,
			        cs_adc,
			        clk_adc,
			        value
					);
	//
endmodule
//
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_00_02\src\ADC_DAC\ADC_MCP3201
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/
