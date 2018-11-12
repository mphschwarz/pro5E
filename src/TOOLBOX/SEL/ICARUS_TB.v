`include "SEL.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	integer file;
	reg clk;
	reg clk_1kHz;
	reg sel; 
	reg cs0;
	reg clk0;
	reg mosi0;
	reg cs1;
	reg clk1;
	reg mosi1;
	wire sel_aktiv;	
	wire cs_out;
	wire clk_out;
	wire mosi_out;
	//
	initial 
		begin
			clk <= 1;
			clk_1kHz <= 1;
			sel <= 0;
			cs0 <= 0;
			clk0 <= 0;
			mosi0 <= 0;
			cs1 <= 0;
			clk1 <= 0;
			mosi1 <= 0;
			//
			$dumpfile("vcd\\\icarus_tb.vcd"); 
			$dumpvars(0, ICARUS_TB); 	
			//
			#10000 sel <= 1;
			#10000 sel <= 0;			
			//
			#10000 $finish; 
		end 
	//
	always #1 clk <= !clk;
	always #10 clk_1kHz <= !clk_1kHz;/* real #25000 */
	always #20 cs0 <= !cs0;
	always #30 clk0 <= !clk0;
	always #40 mosi0 <= !mosi0;
	always #50 cs1 <= !cs1;
	always #60 clk1 <= !clk1;
	always #70 mosi1 <= !mosi1;
	//
	SEL_SPI_INPUT sel_spi_input(clk,
							    clk_1kHz,
								sel,
								cs0,
								clk0,
								mosi0,
								cs1,
								clk1,
								mosi1,
								cs_out,
								clk_out,
								mosi_out,
								sel_aktiv);
	//
	defparam sel_spi_input.DELAY_TIME = 16'd50;
endmodule

/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\NETZFREQUENZ\QUARTUS\FREQUENZMESSUNG\src\CLOCK\WDT
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/
