`include "SPI_HOST.v"
// http://verilogtutorial.blogspot.ch/2012/09/verilog-timescale-system-tasks.html
`timescale 10ns/1ns
//
module ICARUS_TB;
	// SPI_HOST
	integer file;
	reg clk;
	reg spi_cs;
	reg spi_clk;
	reg spi_mosi;
	reg [255:0] data_in;
	reg reset;
	wire spi_host_master;
	wire spi_cs_out;
	wire spi_miso_tri;
	wire spi_miso;
	wire [255:0] data_out;	
	wire data_read;
	wire data_write;
	wire [7:0] cmd;
	wire [7:0] adress;
	wire [7:0] bytes;
	wire [7:0] mux;
	//
	// SPI Beschreibung siehe
	// https://learn.sparkfun.com/tutorials/serial-peripheral-interface-spi
	//
	initial 
		begin
			clk <= 1;		
			// SPI_HOST
			spi_cs <= 1;
			spi_clk <= 0;
			spi_mosi <= 0;
			data_in <= 256'h0119_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0101;	
			reset <= 0;
			//
			$dumpfile("vcd\\\icarus_tb.vcd"); 
			$dumpvars(0, ICARUS_TB); 
			//
			/*
			#4 host_master_1 <= 1;
			#2 data_read_1 <= 1;
			#2 data_read_1 <= 0;
			*/
			//
			#15 spi_cs <= 0;
			#6 spi_cs <= 1;
			#4 spi_cs <= 0;
			#2 spi_cs <= 1;
			#13 spi_cs <= 0;
			// CMD
			#30 spi_mosi <= 1;//0 => MASTER
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 1;//1 => WRITE
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 1;//2 => READ
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//3
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//4
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//5
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//6 
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//7 
			#50 spi_mosi <= 0;
			// WAIT BYTE
			#30 spi_mosi <= 0;//0
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//1
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//2
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//3
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//4
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//5
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//6
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//7
			#50 spi_mosi <= 0;
			// DATEN BYTE 0
			#30 spi_mosi <= 1;//0
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//1
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//2
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//3
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//4
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//5
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//6
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//7
			#50 spi_mosi <= 0;
			// DATEN BYTE 1
			#30 spi_mosi <= 0;//0
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//1
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//2
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//3
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//4
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//5
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//6
			#50 spi_mosi <= 0;
			#30 spi_mosi <= 0;//7
			#50 spi_mosi <= 1;			
			//
			#1979 spi_mosi <= 1;
			#50 spi_mosi <= 0;
			//
			#300 spi_cs <= 1;
			#100 spi_cs <= 0;
			#100 spi_cs <= 1;
			//
			#50 reset <= 1;
			#5 reset <= 0;
			#150 $finish; 
		end 
	//
	always #1 clk <= !clk;
	always #40 
	begin
		if (!spi_cs) spi_clk <= !spi_clk;
		else spi_clk <= 0;
	end
	//
	SPI_HOST spiHost(clk, 
	                 spi_cs, 
					 spi_clk, 
					 spi_mosi, 
					 data_in,
					 reset,
					 spi_miso_tri,
					 spi_miso, 
					 data_out, 
					 data_read, 
					 data_write
					 );
endmodule
//
/*
cd D:\Dropbox\ABBTS_LABOR_DOZ\MOTION_CONTROL\FPGA\QUARTUS\FPGA_MODUL_MAX1000_00_12\src\SPI_FPGA_HOST
C:\iverilog\bin\iverilog -s ICARUS_TB -o icarus_tb.o ICARUS_TB.v
C:\iverilog\bin\vvp icarus_tb.o
*/