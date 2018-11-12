////////////////////////////////////////////////////////////////////////////////////////////
module SPI_HOST (
	input CLK,
	input SPI_CS,
	input SPI_CLK,
	input SPI_MOSI,
	input [255:0] DATA_IN,
	input RESET,
	
	output SPI_MISO_TRI,
	output reg SPI_MISO,
	output reg [255:0] DATA_OUT,
	output reg DATA_READ,
	output reg DATA_WRITE
	);
	//
	reg [0:7] cmd_temp;// LSB
	reg [7:0] cmd;
	reg [255:0] data_in_temp;
	reg [255:0] data_out_temp;		
	reg [11:0] spi_clk_ctr;
	reg [11:0] i_cmd;
	reg [11:0] i_wait;		
	reg [11:0] i_data_miso;
	reg [11:0] i_data_mosi;
	//
	reg delay_data_read;	
	reg delay_data_write;	
	reg spi_activ;
	reg spi_activ_data;
	reg spi_cmd_enable;
	reg spi_cmd_read;
	reg spi_cmd_write;
	reg hri1; reg hri2; reg hri3; reg hri4;
	//
	wire spi_cs_fe;
	wire spi_cs_re;
	wire spi_clk_re;
	wire spi_clk_fe;
	// Filter der Eingaenge
	wire spi_cs_filter;
	wire spi_clk_filter;
	wire spi_mosi_filter;	
	
	parameter SPI_FILTER = 5'd5;
	SPI_INP_FILTER_HOST spi_inp_filter_cs(CLK, SPI_CS, spi_cs_filter);       defparam spi_inp_filter_cs.FILTER = SPI_FILTER;
	SPI_INP_FILTER_HOST spi_inp_filter_clk(CLK, SPI_CLK, spi_clk_filter);    defparam spi_inp_filter_clk.FILTER = SPI_FILTER;
	SPI_INP_FILTER_HOST spi_inp_filter_mosi(CLK, SPI_MOSI, spi_mosi_filter); defparam spi_inp_filter_mosi.FILTER = SPI_FILTER;
	// Glue Logic
	assign SPI_CS_OUT = spi_cs_filter;
	assign SPI_MISO_TRI = !spi_cs_filter && spi_cmd_enable && spi_cmd_read;
	assign spi_cs_re = (hri1 && !hri2);
	assign spi_cs_fe = (!hri1 && hri2);
	assign spi_clk_re = (hri3 && !hri4 && spi_activ);
	assign spi_clk_fe = (!hri3 && hri4 && spi_activ);
	//	
	initial
	begin
		SPI_MISO <= 0;
		DATA_READ <= 0;
		DATA_WRITE <= 0;
		DATA_OUT <= 0;	
		//
		spi_activ <= 0;
		spi_activ_data <= 0;
		spi_cmd_enable <= 0;
		spi_cmd_read <= 0;
		spi_cmd_write <= 0;
		cmd <= 0;
		cmd_temp <= 0;
		
		data_in_temp <= 0;
		data_out_temp <= 0;
		spi_clk_ctr <= 0;
		i_cmd <= 0;
		i_wait <= 0;
		i_data_miso <= 0;
		i_data_mosi <= 0;
		//
		
		delay_data_read <= 0;
		delay_data_write <= 0;
		//
		hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0;		
	end	
	//
	always	@(posedge CLK)
	begin
	//
	hri1 <= spi_cs_filter;
	hri2 <= hri1;			
	//
	if (RESET) 
		begin
		DATA_OUT <= 0;
		end
	//
	if (spi_cs_fe) 
		begin
		spi_activ <= 1;
		spi_clk_ctr <= 0;
		cmd <= 0;
		cmd_temp <= 0;
		//data_out_temp <= 0;				
		i_cmd <= 0;	
		i_wait <= 0;
		i_data_miso <= 0;
		i_data_mosi <= 0;
		delay_data_read <= 0;
		delay_data_write <= 0;
		spi_cmd_enable <= 0;
		spi_cmd_read <= 0;
		spi_cmd_write <= 0;
		end
	//
	// Counter SPI_CLK
	hri3 <= spi_clk_filter;
	hri4 <= hri3;
	if (spi_clk_re && (spi_clk_ctr < 288))
		begin
		spi_clk_ctr <= spi_clk_ctr + 1;
		end
	// SPI Kommunkation beendet
	if (spi_cs_re) 
		begin
		spi_activ <= 0;
		spi_activ_data <= 0;
		SPI_MISO <= 0;
		if (spi_cmd_enable && spi_cmd_write)
			begin
			DATA_OUT <= data_out_temp;	
			end
		delay_data_write <= 1;
		end
	//
	if (spi_cmd_enable && spi_cmd_read)
		begin
		if (delay_data_read)
			begin
			DATA_READ <= 1;
			delay_data_read <= 0;
			end
		else
			DATA_READ <= 0;		
		end
	else
		begin	
		DATA_READ <= 0;		
		delay_data_read <= 0;	
		end
	//
	if (spi_cmd_enable && spi_cmd_write)
		begin
		if (delay_data_write)
			begin
			DATA_WRITE <= 1;
			delay_data_write <= 0;
			end
		else
			DATA_WRITE <= 0;
		end
	else
		begin
		DATA_WRITE <= 0;
		delay_data_write <= 0;		
		end
	// SPI Kommunikation aktiv
	if (spi_clk_re && spi_activ)
		begin
		if ((spi_clk_ctr == 8))
			begin
			cmd <= cmd_temp;
			end	
		if (spi_clk_ctr == 10) 
			begin
			delay_data_read <= 1;
			spi_cmd_read <= cmd[5];
			spi_cmd_write <= cmd[6];
			spi_cmd_enable <= cmd[7];
			end
		// Uebernahme der Inputdaten
		if (spi_clk_ctr == 13)
			begin
			data_in_temp <= DATA_IN;
			end
		// setze Flag SPI_MISO negedge clk
		if (spi_clk_ctr == 15)
			begin
			spi_activ_data <= 1;
			end
		// Kommandoword
		if (spi_clk_ctr < 8)
			begin
			cmd_temp[i_cmd] <= spi_mosi_filter;
			i_cmd <= i_cmd + 1;
			end
		// wait Byte
		else if (spi_clk_ctr < 16)
			begin
			i_wait <= i_wait + 1;
			end
		// Datenempfang
		else if (spi_clk_ctr < 272)
			begin
			if (spi_cmd_write && (i_data_miso < 256))
				data_out_temp[i_data_miso] <= spi_mosi_filter;
				i_data_miso <= i_data_miso + 1;
			end
		end
		// Datenversand
		if (spi_clk_fe && spi_activ_data && (spi_clk_ctr < 272))
			begin
			if (spi_cmd_read && (i_data_mosi < 256))
				SPI_MISO <= data_in_temp[i_data_mosi];
			else
				SPI_MISO <= 0;
			i_data_mosi <= i_data_mosi + 1;
			end
		end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
//	Digitales Filter der Eingangssignale
module	SPI_INP_FILTER_HOST (
	input CLK, 
	input IN,
	output reg OUT
	);
//
parameter FILTER = 5'd5;
//
reg [4:0] ctr0;
reg [4:0] ctr1;
//
initial
	begin
	OUT <= 0;
	ctr0 <= 0;
	ctr1 <= 0;
	end
always	@(posedge CLK)
begin
	if (IN && !OUT)
		begin
		ctr0 <= 0;
		ctr1 <= ctr1 + 1;
		end
	//	
	if (!IN && OUT)
		begin
		ctr0 <= ctr0 + 1;
		ctr1 <= 0;
		end	
	//
	if (ctr0 == FILTER)
		begin
		ctr0 <= 0;
		ctr1 <= 0;
		OUT <= 0;
		end
	//
	if (ctr1 == FILTER)
		begin
		ctr0 <= 0;
		ctr1 <= 0;
		OUT <= 1;
		end
	//	
	if (((ctr0 > 0) && IN) || ((ctr1 > 0) && !IN))
		begin
		ctr0 <= 0;
		ctr1 <= 0;
		end	
end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////