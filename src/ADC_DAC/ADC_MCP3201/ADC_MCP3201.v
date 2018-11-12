module ADC_MCP3201 (
	input CLK,
	input LATCH,
	input SDI_ADC,
	output reg CS_ADC,
	output reg CLK_ADC,
	output reg [11:0] VALUE
	);
	//
	reg [15:0] ctr_clk_spi;
	reg [11:0] index;
	reg [11:0] value_temp;
	reg [4:0] state;
	reg [11:0] ctr_clk_cs;// Testvariable
	//
	reg hri1; reg hri2; reg hri3; reg hri4;
	wire latch_start;
	wire clk_adc_re;
	wire clk_adc_fe;	
	//
	assign	latch_start = (hri1 && !hri2);
	assign	clk_adc_re = (hri3 && !hri4);
	assign	clk_adc_fe = (!hri3 && hri4);
	//	
	initial
	begin
		
		CS_ADC <= 1;
		CLK_ADC <= 0;
		VALUE <= 0;
		index <= 15;
		value_temp <= 0;
		state <= 0;
		ctr_clk_spi <= 1;
		ctr_clk_cs <= 1;
		//
		hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0;
	end	
	//
	always	@(posedge CLK)
	begin
	// Impulsauswertung
	hri1 <= LATCH;
	hri2 <= hri1;
	hri3 <= CLK_ADC;
	hri4 <= hri3;
	// Testroutine
	if (CS_ADC == 0) ctr_clk_cs <= ctr_clk_cs + 1;
	else ctr_clk_cs <= 1;
	
	//
	if (state == 0) 
		begin
		CS_ADC <= 1;
		index <= 15;
		value_temp <= 0;
		ctr_clk_spi <= 1;
		//
		if(latch_start) 
			begin
			CS_ADC <= 0;
			state <= 1;
			end
		//
		end
	//
	if (state == 1) 
		begin
		ctr_clk_spi <= ctr_clk_spi + 1;
		if (ctr_clk_spi == 25) 
			begin
			ctr_clk_spi <= 1;
			CLK_ADC <= !CLK_ADC;
			end
		//
		if (clk_adc_re)
			begin
			value_temp[index - 1] <= SDI_ADC;
			end
		//
		if (clk_adc_fe) index <= index - 1;
		//
		if (index == 0) state <= 2;
		end

	if (state == 2) 
		begin
		VALUE <= value_temp[11:0];
		state <= 0;
		end
	end
endmodule