`include "CLIENT_MCP23S17.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg spi_miso;
	reg [15:0] led;
	wire spi_cs;
	wire spi_clk;
	wire spi_mosi;
	wire [15:0] sw;
	//
	initial 
	begin
		clk <= 1;
		spi_miso <= 0;
		led <= 0;
		//		
		$dumpfile("vcd\\\icarus_tb.vcd"); 
		$dumpvars(0, ICARUS_TB); 		
		//
		#100 spi_miso <= 1;
		#120 spi_miso <= 0;
		#100000 $finish; 
	end 
	//
	always #1        clk <= !clk;// 50MHz
	//
	CLIENT_MCP23S17 client_mcp23s17(clk,
								    spi_miso,
								    led,
								    spi_cs,
								    spi_clk,
								    spi_mosi,
								    sw);		
	//
endmodule
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA_MODUL_MAX1000_DIT_RET_UR\FPGA_MODUL_MAX1000_DIT_RET_UR_01_00\src\APP_TIMER
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/