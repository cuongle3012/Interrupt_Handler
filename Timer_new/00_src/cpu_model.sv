module cpu_model (input pclk,
		  input preset_n,
		  input pslverr,
		  input pready,
		  input [31:0] prdata,
		  output reg pwrite,
		  output reg psel,
		  output reg penable,
		  output reg [31:0] paddr,
		  output reg [31:0] pwdata
		  );
initial begin
pwrite = 1'b0;
psel = 1'b0;
penable = 1'b0;
paddr = 32'b0;
pwdata = 32'b0;
end

always @(posedge pclk or negedge preset_n) begin	//0 can bat xung pclk
if (!preset_n) begin
	   pwrite = 1'b0;
	   psel = 1'b0;
	   penable = 1'b0;
	   paddr = 32'b0;
	   pwdata = 32'b0;
	end
	else begin
	   pwrite = pwrite;
	   psel = psel;
	   penable = penable;
	   paddr = paddr;
	   pwdata = pwdata;
	end
end

task write_data (input [31:0] address, input [31:0] data, output err);
begin
	@(posedge pclk);
	#1;
	pwrite = 1'b1;
	psel = 1'b1;
	paddr = address;
	pwdata = data;
	$display("At %0t start writing wdata='h0%0d to address = 32'h%0h", $time, data, address);

	@(posedge pclk);
	#1;
	penable = 1'b1;

	@(posedge pclk);
	while (!pready) @(posedge pclk);
	if (pslverr) begin
	$display("At %0t address ('h%0h) no-existed -- Error address", $time, address);
	err = pslverr;
	err = 1'b0;
	end
	#1;
	pwrite = 1'b0;
	psel = 1'b0;
	paddr = 32'd0;
	pwdata = 32'd0;
	penable = 1'b0;
	$display("At %0t write transfer completed", $time);
end
endtask

task read_data (input [31:0] address, output [31:0] data, output err);
begin
	@(posedge pclk);
	#1;
	pwrite = 1'b0;
	psel = 1'b1;
	paddr = address;
	$display("At %0t start reading from address=32'h%0h", $time, address);

	@(posedge pclk);
	#1;
	penable = 1'b1;

	@(posedge pclk);
	while (!pready) @(posedge pclk);
	data = prdata;
	if (pslverr) begin
	$display("At %0t address ('h%0h) no-existed -- Error address", $time, address);
	err = pslverr;
	err = 1'b0;
	end
	#1;
	pwrite = 1'b0;
	psel = 1'b0;
	paddr = 32'd0;
	penable = 1'b0;
	$display("At %0t read transfer completed", $time);

end
endtask

endmodule
