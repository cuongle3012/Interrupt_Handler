module clk_sel(input pclk,
               input preset_n,
	       input [1:0] cks,      
               output clk_int
               );

reg clk2, clk4, clk8, clk16, clk_int_reg;

wire pclk2, pclk4, pclk8, pclk16;

always @(*) begin
	case (cks)
	2'b00: clk_int_reg = clk2;
	2'b01: clk_int_reg = clk4;
	2'b10: clk_int_reg = clk8;
	2'b11: clk_int_reg = clk16;
	default: clk_int_reg = 1'b0;
	endcase
end

assign clk_int = clk_int_reg;

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) clk2 <= 1'b0;
	else clk2 <= !clk2;
end

assign pclk2 = clk2;

always @(posedge pclk2 or negedge preset_n) begin
	if (!preset_n) clk4 <= 1'b0;
	else clk4 <= !clk4;
end

assign pclk4 = clk4;

always @(posedge pclk4 or negedge preset_n) begin
	if (!preset_n) clk8 <= 1'b0;
	else clk8 <= !clk8;
end

assign pclk8 = clk8;

always @(posedge pclk8 or negedge preset_n) begin
	if (!preset_n) clk16 <= 1'b0;
	else clk16 <= !clk16;
end

assign pclk16 = clk16;

endmodule
