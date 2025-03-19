module clock_system (output reg pclk,
		     output reg preset_n
		     );

initial begin
pclk = 1'b0;
forever begin
#10;
pclk = !pclk;
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