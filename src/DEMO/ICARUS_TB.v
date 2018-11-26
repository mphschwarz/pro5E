`include "DEMO.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg clk_1MHz;
	reg clk_100kHz;
	reg clk_10Hz;
	reg clk_1Hz;
	reg in0;
	reg in1;
	reg in2;
	reg in3;
	reg in4;
	reg in5;
	reg in6;
	reg in7;
	reg [15:0] in16bit1;
	reg [15:0] in16bit2;
	reg [15:0] in16bit3;
	reg [15:0] in16bit4;
	wire out0;
	wire out1;
	wire out2;
	wire out3;
	wire out4;
	wire out5;
	wire out6;
	wire out7;
	wire [15:0] out16bit1;
	wire [15:0] out16bit2;
	wire [15:0] out16bit3;
	wire [15:0] out16bit4;
	//
	initial 
		begin
		clk <= 1;
		clk_1MHz <= 1;
		clk_100kHz <= 1;
		clk_10Hz <= 1;
		clk_1Hz <= 1;
		in0 <= 0;
		in1 <= 0;
		in2 <= 0;
		in3 <= 0;
		in4 <= 0;
		in5 <= 0;
		in6 <= 0;
		in7 <= 0;
		in16bit1 <= 0;
		in16bit2 <= 0;
		in16bit3 <= 0;
		in16bit4 <= 0;
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#10 in0 <= 1;
		#10 begin
				in0 <= 0;
				in6 <= 1;
				in7 <= 1;
			end
		#10 begin
				in6 <= 0;
				in7 <= 1;
			end
		#10 begin
				in6 <= 0;
				in7 <= 0;
			end		
		//
		#100000 $finish; 
		end 
	//
	always #1        clk <= !clk;// 50MHz => Systemclock
	always #50       clk_1MHz <= !clk_1MHz;// 1MHz
	always #5000     clk_100kHz <= !clk_100kHz;// 100kHz
	always #5000000  clk_10Hz <= !clk_10Hz;// 10Hz
	always #50000000 clk_1Hz <= !clk_1Hz;// 1Hz
	//
	DEMO demo(clk, 
	          clk_1MHz,
			  clk_100kHz,
			  clk_10Hz,
	          clk_1Hz,
			  in0,
			  in1,
			  in2,
			  in3,
			  in4,
			  in5,
			  in6,
			  in7,
			  in16bit1,
			  in16bit2,
			  in16bit3,
			  in16bit4,
			  out0,
			  out1,
			  out2,
			  out3,
			  out4,
			  out5,
			  out6,
			  out7,
			  out16bit1,
			  out16bit2,
			  out16bit3,
			  out16bit4);					
	//
endmodule

/*
cd D:\Dropbox\ABBTS_DIT2_DOZ\QUARTUS\FPGA_MODUL_MAX1000_DIT_RET_UR_02_91_FINAL_BETA\src\DEMO
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/