`include "../ADC_MCP3201.v"
`include "ADC_MCP3201_MOV_AVG.v"
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
	wire cs_adc_avg;
	wire clk_adc_avg;
	wire [11:0] value_avg;	
	wire latch_dac;
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
		#50 latch <= 1;
		#62  latch <= 0;
		//
		#180  sdi_adc <= 0;// NULL BIT
		#120  sdi_adc <= 1;// B11
		#120  sdi_adc <= 0;// B10
		#120  sdi_adc <= 0;// B9
		#120  sdi_adc <= 0;// B8
		#120  sdi_adc <= 0;// B7
		#120  sdi_adc <= 0;// B6
		#120  sdi_adc <= 0;// B5
		#120  sdi_adc <= 0;// B4
		#120  sdi_adc <= 0;// B3
		#120  sdi_adc <= 0;// B2
		#120  sdi_adc <= 0;// B1
		#120  sdi_adc <= 1;// B0
		#120  sdi_adc <= 0;// HI-Z
		//
		#15000 latch <= 1;
		#62  latch <= 0;
		//
		#15000 $finish; 
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
	ADC_MCP3201_MOV_AVG adc_mcp3201_mov_avg(
					clk,
	                latch,
			        sdi_adc,
			        cs_adc_avg,
			        clk_adc_avg,
			        value_avg,
					latch_dac
					);
	//
endmodule
//
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA\FPGA_MODUL_MAX1000_00_21\src\DC_MOTOR
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/
