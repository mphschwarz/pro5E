`include "IO16_VERILOG.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg clk_1MHz;
	reg clk_1Hz;
	reg s1;
	reg s2;
	reg s3;
	reg s4;
	reg s5;
	reg s6;
	reg s7;
	reg s8;
	reg s9;
	reg s10;
	reg s11;
	reg s12;
	reg s13;
	reg s14;
	reg s15;
	reg s16;	
	//
	wire led1;
	wire led2;
	wire led3;
	wire led4;	
	wire led5;
	wire led6;
	wire led7;
	wire led8;	
	wire led9;	
	wire led10;	
	wire led11;	
	wire led12;	
	wire led13;	
	wire led14;	
	wire led15;	
	wire led16;		
	//
	initial 
		begin
		clk <= 1;
		clk_1MHz <= 1;
		clk_1Hz <= 1;
		s1 <= 0;
		s2 <= 0;
		s3 <= 0;
		s4 <= 0;
		s5 <= 0;
		s6 <= 0;
		s7 <= 0;
		s8 <= 0;
		s9 <= 0;
		s10 <= 0;
		s11 <= 0;
		s12 <= 0;
		s13 <= 0;
		s14 <= 0;
		s15 <= 0;
		s16 <= 0;		
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#10 s9 <= 1;
		#10 s9 <= 0;
		#10 s9 <= 1;
		#10 s9 <= 0;
		#10 s9 <= 1;
		#10 s9 <= 0;
		#10 s9 <= 1;
		#10 s9 <= 0;
		#10 s9 <= 1;
		#10 s9 <= 0;
		#10 s10 <= 1;
		#10 s10 <= 0;
		#10 s10 <= 1;
		#10 s10 <= 0;
		#10 s11 <= 1;
		#10 s11 <= 0;
		
		
		//
		#10 $finish; 
		end 
	//
	always #1        clk <= !clk;// 50MHz
	always #50       clk_1MHz <= !clk_1MHz;// 1MHz	
	always #50000000 clk_1Hz <= !clk_1Hz;// 1Hz		
	//
	IO16_VERILOG io16_verilog(clk,
							  clk_1MHz,
							  clk_1Hz,
							  s1,
							  s2,
							  s3,
							  s4,
							  s5,
							  s6,
							  s7,
							  s8,
							  s9,
							  s10,
							  s11,
							  s12,
							  s13,
							  s14,
							  s15,
							  s16,
							  led1,
							  led2,
							  led3,
							  led4,
							  led5,
							  led6,
							  led7,
							  led8,
							  led9,
							  led10,
							  led11,
							  led12,
							  led13,
							  led14,
							  led15,
							  led16
							);					
	//
endmodule
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_00_02\src\BASIS\VERILOG\GLUE_LOGIC
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/