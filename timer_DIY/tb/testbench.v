module testbench ();

wire pclk, preset_n, test_clk_int;

wire pwrite, psel, penable, pready, pslverr;

wire [7:0] paddr, pwdata, prdata;

wire [7:0] test_tdr, test_cnt, test_last_cnt;

wire [2:0] test_count;

assign test_clk_int = dut.sys_clk.clk_int;
assign test_count = dut.reg_control.count;
assign test_tdr = dut.reg_control.tdr_reg;
assign test_cnt = dut.counter_module.cnt_reg;
assign test_last_cnt = dut.counter_module.last_cnt_reg;

clock_system system (.pclk(pclk),
		     .preset_n(preset_n)
		     );
		     
timer dut      (.pclk(pclk),
		.preset_n(preset_n),
		.pwrite(pwrite),
		.psel(psel),
		.penable(penable),
		.paddr(paddr),
		.pwdata(pwdata),
		.prdata(prdata),
		.pready(pready),
		.pslverr(pslverr)
		);

cpu_model cpu (.pclk(pclk),
	       .preset_n(preset_n),
	       .pwrite(pwrite),
	       .psel(psel),
	       .penable(penable),
	       .paddr(paddr),
	       .pwdata(pwdata),
	       .pready(pready),
	       .pslverr(pslverr),
	       .prdata(prdata)
	       );

task get_reset();
  begin
    system.preset_n = 1'b0;
    #20;
    system.preset_n = 1'b1;
  end
endtask

task get_result(input reg a);			//nen co cai nay cho de
	begin
	     if (a) begin
	     $display("=============================");
	     $display("========= TEST FAILED =======");
	     $display("=============================");
	     end
	     else begin
	     $display("=============================");
	     $display("========= TEST PASSED =======");
	     $display("=============================");
	     end
	end
endtask
endmodule
