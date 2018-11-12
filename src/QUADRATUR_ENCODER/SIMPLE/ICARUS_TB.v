`include "QUADRATUR_ENCODER_SIMPLE.v"

// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg a;
	reg b; 
	reg reset;
	wire signed [31:0] counter;
	wire cw;
	wire ccw;
	//
	initial 
		begin
			clk <= 1;
			a <= 0;
			b <= 0;
			reset <= 0;
			//
			$dumpfile("vcd\\\icarus_tb.vcd"); 
			$dumpvars(0, ICARUS_TB); 
			//
			#50 a <= 1;
			#50 b <= 1;
			#50 a <= 0;
			#50 b <= 0;
			#50 a <= 1;
			#50 b <= 1;
			#50 a <= 0;
			#50 b <= 0;
			//
			#50 a <= 0;
			#50 b <= 1;
			#50 a <= 1;
			#50 b <= 0;
			#50 a <= 0;
			#50 b <= 1;
			#50 a <= 1;
			#50 b <= 0;
			//
			#500 $finish; 
		end 
	//
	always #1 clk <= !clk;
	//
	QUADRATUR_ENCODER_SIMPLE quadratur_encodersimple(clk,
										a,
										b,
										reset,
										counter,
										cw,
										ccw
										);
	//
endmodule
/*
cd D:\ABBTS\LABOR\FPGA\_PLC_ADC_DAC\QUARTUS\MAX10_DC_MOTOR\src\TOOLBOX\ENCODER
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/