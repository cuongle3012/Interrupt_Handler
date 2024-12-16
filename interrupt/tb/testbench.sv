module testbench;
	logic [3:0] clk;
	logic pclk;
	logic preset_n;
	logic psel;
	logic pwrite;
	logic penable;
	logic [7:0] paddr, pwdata, prdata;
	logic finish_flag;
	logic err_apb;
	logic cp_err;
	logic pready;
	logic pslverr;
	int err = 0;

	logic NMI;
	logic i_bit;
	logic [7:0] IRQ, Int_IRQ;
	logic intr_ev;
	logic [4:0] vt_no;


	interrupt_controller intr_ctrl(
	.pclk(pclk),
	.preset_n(preset_n),
	.pwrite(pwrite),
	.psel(psel),
	.penable(penable),
	.pready(pready),
	.paddr(paddr),
	.pwdata(pwdata),
	.prdata(prdata),
	.pslverr(pslverr),
	.NMI(NMI),
	.IRQ(IRQ),
	.Int_IRQ(Int_IRQ),
	.i_bit(i_bit),
	.intr_ev(intr_ev),
	.vt_no(vt_no),
	.I_flag(),
	.UI_flag()
	);

	cpu_model cpu(.pclk(pclk),
					.preset_n(preset_n),
					.pslverr(psvlerr),
					.pwrite(pwrite),
					.psel(psel),
					.penable(penable),
					.pready(pready),
					.paddr(paddr),
					.pwdata(pwdata),
					.prdata(prdata),
					.NMI(NMI),
					.IRQ(IRQ),
					.Int_IRQ(Int_IRQ),
					.i_bit(i_bit),
					.I_flag(),
					.UI_flag());

	generator gen(.pclk(pclk),
					.preset_n(preset_n),
					.clk(clk));

	// timer timer(.pclk(pclk),
	// 				.preset_n(preset_n),
	// 				.psel(psel),
	// 				.pwrite(pwrite),
	// 				.penable(penable),
	// 				.pwdata(pwdata),
	// 				.paddr(paddr),
	// 				.prdata(),
	// 				.pready(),
	// 				.pslverr(),
	// 				.ovf_flag(ovf_flag),
	// 				.udf_flag(udf_flag));

	// monitor monitor(.complete_flag(complete_flag),
	// 					.cp_err(cp_err),
	// 					.err(err_apb));

	// logic [7:0] test_00, test_01, test_02, test_03, test_04, test_05, test_06, test_07, test_08, test_09, test_0a, test_0b, test_0c, test_0d, test_0e;
	// logic [7:0] w_test_00, w_test_01, w_test_02, w_test_03, w_test_04, w_test_05, w_test_06, w_test_07, w_test_08, w_test_09, w_test_0a, w_test_0b, w_test_0c, w_test_0d, w_test_0e;

	// logic [7:0] mask_00, mask_01, mask_02, mask_03, mask_04, mask_05, mask_06, mask_07, mask_08, mask_09, mask_0a, mask_0b, mask_0c, mask_0d, mask_0e;

	// assign test_00 = sb.

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