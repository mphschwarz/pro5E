module ADC_MCP3201_MOV_AVG(
	input CLK,
	input LATCH,
	input SDI_ADC,
	output CS_ADC,
	output CLK_ADC,
	output reg [11:0] VALUE,
	output reg LATCH_DAC
	);
	//
	localparam CTR_LATCH_LIMIT = 818;
	localparam CTR_SAMPLE_LIMIT = 40;
	//
	reg [11:0] ctr_latch;
	reg ctr_latch_enable;
	reg [11:0] ctr_sample;
	reg [10:0] ctr_mov_avg;
	reg [11:0] value_adc_1;
	reg [11:0] value_adc_2;
	reg [11:0] value_adc_3;
	reg [11:0] value_adc_4;
	reg [15:0] summe_mov_avg;
	reg [15:0] value_temp;
	reg [5:0] state;
	//
	reg hri1; reg hri2; reg hri3; reg hri4;
	wire latch_start;
	wire latch_cs_re;
	wire latch_adc;
	wire [11:0] value_adc;
	//
	assign latch_adc = latch_start || (ctr_latch == CTR_LATCH_LIMIT);
	ADC_MCP3201 adc_mcp3201(CLK, latch_adc, SDI_ADC, CS_ADC, CLK_ADC, value_adc);
	//
	assign	latch_start = (hri1 && !hri2);
	assign	latch_cs_re = (hri3 && !hri4);	
	//	
	initial
	begin
		VALUE <= 0;
		LATCH_DAC <= 0;
		ctr_latch <= 1;
		ctr_latch_enable <= 1;
		ctr_sample <= 0;
		value_adc_1 <= 0;
		value_adc_2 <= 0;
		value_adc_3 <= 0;
		value_adc_4 <= 0;		
		ctr_mov_avg <= 1;
		summe_mov_avg <= 0;
		value_temp <= 0;
		state <= 6'd0;
		//
				hri1 <= 0; hri2 <= 0; hri3 <= 0; hri4 <= 0;
	end	
	//
	always	@(posedge CLK)
	begin
	// START
	hri1 <= LATCH;
	hri2 <= hri1;
	//
	hri3 <= CS_ADC;
	hri4 <= hri3;
	//
	// Latch adc
	if (latch_start) 
		begin
		ctr_latch <= 1;
		ctr_latch_enable <= 1;
		ctr_sample <= 0;
		end
	//
	if (ctr_latch_enable) ctr_latch <= ctr_latch + 1;
	if (ctr_latch == CTR_LATCH_LIMIT)
		begin
		ctr_latch <= 1;
		ctr_sample <= ctr_sample + 1;
		end
	//
	if ((ctr_sample == CTR_SAMPLE_LIMIT) && ctr_latch_enable) ctr_latch_enable <= 0;
	//
	// Moving Average
	if (latch_cs_re)
		begin
		ctr_mov_avg <= ctr_mov_avg + 1;
		if (ctr_mov_avg == 4) ctr_mov_avg <= 1;
		case(ctr_mov_avg)
			1: value_adc_1 <= value_adc;
			2: value_adc_2 <= value_adc;
			3: value_adc_3 <= value_adc;
			4: value_adc_4 <= value_adc;
			endcase
		state <= 6'd1;
		end
	if (state == 6'd1)
		begin
		summe_mov_avg <= 0;
		state <= state + 6'd1;
		end
	if (state == 6'd2)
		begin
		summe_mov_avg <= summe_mov_avg + value_adc_1;
		state <= state + 6'd1;
		end
	if (state == 6'd3)
		begin
		summe_mov_avg <= summe_mov_avg + value_adc_2;
		state <= state + 1;
		end
	if (state == 6'd4)
		begin
		summe_mov_avg <= summe_mov_avg + value_adc_3;
		state <= state + 6'd1;
		end
	if (state == 6'd5)
		begin
		summe_mov_avg <= summe_mov_avg + value_adc_4;
		state <= state + 6'd1;
		end		
	if (state == 6'd6)
		begin
		value_temp <=  summe_mov_avg / 4;
		state <= state + 6'd1;
		end
	if (state == 6'd7)
		begin
		VALUE[11:0] <= value_temp[11:0];
		state <= state + 6'd1;
		end				
	if ((state >= 6'd8) && (state < 6'd58))
		begin
		LATCH_DAC <= 1;
		state <= state + 6'd1;
		end
	if (state == 6'd58)
		begin
		LATCH_DAC <= 0;
		state <= state + 6'd1;
		end
	//
	end
endmodule