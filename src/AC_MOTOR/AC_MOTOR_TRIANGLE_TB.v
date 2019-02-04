`include "AC_MOTOR_TRIANGLE.v"
`timescale 10ns/1ns

module AC_MOTOR_TRIANGLE_TB;
	integer file;
	reg clk;
	reg cw_in;
	reg ccw_in;
	// reg [4:0] amplitude;
	//
	wire signed [12+12:0] triangle;
	wire cw_out;
	wire ccw_out;
	wire lock;
	//
	initial begin
		clk <= 1;
		cw_in <= 0;
		ccw_in <= 1;
		//
		// amplitude <= 1;
		//
		$dumpfile("vcd/ac_motor_triangle_tb.vcd"); 
		$dumpvars(0, AC_MOTOR_TRIANGLE_TB); 
		#25000 $finish; 
		// #1000000 $finish;
	end 
	//
	always #1 clk <= !clk;
	//
	AC_MOTOR_TRIANGLE ac_motor(
		clk,
		cw_in,
		ccw_in,
		// amplitude,
		cw_out,
		ccw_out,
		lock,
		triangle);
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
