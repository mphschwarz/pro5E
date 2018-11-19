`include "GLUE_LOGIC.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg clk_1MHz;
	reg clk_1Hz;
	reg in4;
	reg in5;
	reg in6;
	reg in7;
	wire out4;
	wire out5;
	wire out6;
	wire out7;	
	//
	initial 
		begin
			clk <= 1;
			clk_1MHz <= 1;
			clk_1Hz <= 1;
			in4 <= 0;
			in5 <= 0;
			in6 <= 0;
			in7 <= 0;
			//		
			$dumpfile("vcd\\\icarus_tb.vcd"); 
			$dumpvars(0, ICARUS_TB); 		
			//
			#4 begin in4 <= 0; in5 <= 0; in6 <= 0; in7 <= 0; end
			#4 begin in4 <= 0; in5 <= 0; in6 <= 0; in7 <= 1; end
			#4 begin in4 <= 0; in5 <= 0; in6 <= 1; in7 <= 0; end
			#4 begin in4 <= 0; in5 <= 0; in6 <= 1; in7 <= 1; end
			#4 begin in4 <= 0; in5 <= 1; in6 <= 0; in7 <= 0; end
			#4 begin in4 <= 0; in5 <= 1; in6 <= 0; in7 <= 1; end
			#4 begin in4 <= 0; in5 <= 1; in6 <= 1; in7 <= 0; end
			#4 begin in4 <= 0; in5 <= 1; in6 <= 1; in7 <= 1; end
			#4 begin in4 <= 1; in5 <= 0; in6 <= 0; in7 <= 0; end
			#4 begin in4 <= 1; in5 <= 0; in6 <= 0; in7 <= 1; end
			#4 begin in4 <= 1; in5 <= 0; in6 <= 1; in7 <= 0; end
			#4 begin in4 <= 1; in5 <= 0; in6 <= 1; in7 <= 1; end
			#4 begin in4 <= 1; in5 <= 1; in6 <= 0; in7 <= 0; end
			#4 begin in4 <= 1; in5 <= 1; in6 <= 0; in7 <= 1; end
			#4 begin in4 <= 1; in5 <= 1; in6 <= 1; in7 <= 0; end
			#4 begin in4 <= 1; in5 <= 1; in6 <= 1; in7 <= 1; end	
			//
			#4 $finish; 
		end 
	//
	always #1        clk <= !clk;// 50MHz
	always #50       clk_1MHz <= !clk_1MHz;// 1MHz	
	always #50000000 clk_1Hz <= !clk_1Hz;//
	//
	GLUE_LOGIC glue_logic(clk,
						  clk_1MHz,
						  clk_1Hz,
						  in4,
						  in5,
						  in6,
						  in7,
						  out4,
						  out5,
						  out6,
						  out7);					
endmodule

/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_00_02\src\BASIS\VERILOG\GLUE_LOGIC
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/