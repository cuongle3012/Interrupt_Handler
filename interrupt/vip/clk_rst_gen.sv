module generator (output reg pclk,
		     output reg preset_n
			  ,output reg [3:0] clk
		     );

initial begin
pclk = 1'b0;
forever begin
#5;
pclk = !pclk;
end
end

initial begin		//0 hieu cai nay lam j?
clk[0] = 1'b0;
forever begin
#10;
clk[0] = !clk[0];
end
end

initial begin
clk[1] = 1'b0;
forever begin
#20;
clk[1] = !clk[1];
end
end

initial begin
clk[2] = 1'b0;
forever begin
#40;
clk[2] = !clk[2];
end
end

initial begin
clk[3] = 1'b0;
forever begin
#80;
clk[3] = !clk[3];
end
end

initial begin
preset_n = 1'b1;
#10;
preset_n = 1'b0;
#50;
preset_n = 1'b1;
end

endmodule
