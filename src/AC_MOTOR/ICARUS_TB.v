`include "AC_MOTOR.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	//
	integer file;
	reg clk;
	reg enable;
	reg cw;
	reg ccw;
	reg [11:0] frequency;
	reg [11:0] amplitude;
	reg [11:0] adc_cmp;
	reg [11:0] adc;	
	wire out_1;
	wire out_2;
	wire en_1;
	wire en_2;
	wire adc_latch;
	//
	reg signed [14:0] value_in;
	wire cw_out;
	wire ccw_out;
	wire signed [11:0] value_out;
	wire signed [11:0] sin_val;
	//
	initial 
	begin
		clk <= 1;
		enable <= 1;
		cw <= 0;
		ccw <= 1;
		//
		amplitude <= 1;
		frequency <= 2;
		//
		adc_cmp <= 3000;
		adc <= 2500;
		//
		value_in <= 100;
		//
		$dumpfile("vcd/icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 
		//
		// #300 value_in <= 20;
		// #300 value_in <= 30;
		// #300 value_in <= 15;
		// #300 value_in <= -15;
		// #300 value_in <= 5;
		// #300 value_in <= -150;
		// #100 value_in <= 100;
		
		
		//
		#125000 adc <= 4000;
		#10 adc <= 1000;
		//
		#25000 $finish; 
		// #1000000 $finish;
	end 
	//
	always #1 clk <= !clk;
	//
	AC_MOTOR ac_motor(
		clk,
		enable,
		cw,
		ccw,
		amplitude,
		frequency,
		adc_cmp,
		adc,
		out_1,
		out_2,
		en_1,
		en_2,
		adc_latch
		);
	//
endmodule
//

/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA\FPGA_MODUL_MAX1000_00_21\src\DC_MOTOR
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o

oder 

cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA\FPGA_MODUL_MAX1000_SA_01_00\src\DC_MOTOR
D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA\FPGA_MODUL_MAX1000_SA_01_00\icarus\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA\FPGA_MODUL_MAX1000_SA_01_00\icarus\iverilog\bin\vvp icarus_tb.o
*/
