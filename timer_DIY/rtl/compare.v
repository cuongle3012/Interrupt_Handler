module compare (input pclk,
                input preset_n,
                input [7:0] last_cnt,
		input [7:0] cnt,
                input en,
		input updw,
		input load,
                input [1:0] trig_clr,
                output udf_trig,
                output ovf_trig
                );

reg ovf_trig_reg, udf_trig_reg;

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) ovf_trig_reg <= 1'b0;
	else if (trig_clr[0]) ovf_trig_reg <= 1'b0;	//xoa co underflow
	else if (en && (last_cnt == 8'hff) && (cnt == 0) && (!updw) && (!load)) ovf_trig_reg <= 1'b1;	//set 1 by hardware
	else ovf_trig_reg <= 1'b0;
end

assign ovf_trig = ovf_trig_reg;

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) udf_trig_reg <= 1'b0;
	else if (trig_clr[1]) udf_trig_reg <= 1'b0;
	else if (en && (last_cnt == 0) && (cnt == 8'hff) && updw && (!load)) udf_trig_reg <= 1'b1;
	else udf_trig_reg <= 1'b0;
end

assign udf_trig = udf_trig_reg;

endmodule
