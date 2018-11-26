module DC_MOTOR (
	input CLK,
	input ENABLE,
	input CW,
	input CCW,
	input [11:0] VALUE,
	input [11:0] ADC_CMP,
	input [11:0] ADC,
	output reg OUT1,
	output reg OUT2,
	output EN1,
	output EN2,	
	output reg ADC_LATCH);
	//
	assign EN1 = ENABLE;
	assign EN2 = ENABLE;
	//
	reg cw_temp;
	reg ccw_temp;
	reg [13:0] value_temp;
	reg [13:0] adc_cmp_temp;
	reg [11:0] adc_temp;
	reg en_adc;
	reg [13:0] ctr;
	reg ctr_dir;
	reg [13:0] ctr_adc_latch;
	initial
		begin
			OUT1 <= 0;
			OUT2 <= 0;
			ADC_LATCH <= 0;
			//
			cw_temp <= 0;
			ccw_temp <= 0;
			value_temp <= 0;
			adc_cmp_temp <= 0;
			adc_temp <= 0;
			en_adc <= 1;
			ctr <= 16383;
			ctr_dir <= 1;
			ctr_adc_latch <= 1;
			//
		end
	//
	always @(posedge CLK)
	begin
		// Pulsblocker
		adc_temp[11:0] <= ADC[11:0];
		if (adc_temp > adc_cmp_temp) en_adc <= 0;
		//
		if (ctr == 16383) 
			begin
			cw_temp <= CW;
			ccw_temp <= CCW;
			value_temp[13:2] <= VALUE[11:0];
			//if (VALUE <= 14745) value_temp[13:2] <= VALUE[11:0];
			//else value_temp <= 14745;
			adc_cmp_temp[11:0] <= ADC_CMP[11:0];			
			en_adc <= 1;
			end
		//
		if (ctr == 1) ctr_dir <= 1;
		if (ctr == 16382) ctr_dir <= 0;
		//
		if (ctr_dir) ctr <= ctr + 1;
		else ctr <= ctr - 1;	
		//
		if ((value_temp >= ctr) && (value_temp > 0) && en_adc)
			begin
			//
			if (cw_temp && !ccw_temp)
				begin
				OUT1 <= 1;
				OUT2 <= 0;
				end
			//	
			if (!cw_temp && ccw_temp)
				begin
				OUT1 <= 0;
				OUT2 <= 1;
				end
			//
			end
		else
			begin
			OUT1 <= 0;
			OUT2 <= 0;
			end
		// ADC Latch
		if (ctr == 16383) ADC_LATCH <= 1;
		if (ADC_LATCH) ctr_adc_latch <= ctr_adc_latch + 1;	
		if (ctr_adc_latch == 50)
			begin
			ctr_adc_latch <= 1;
			ADC_LATCH <= 0;
			end		
		//
	end
endmodule