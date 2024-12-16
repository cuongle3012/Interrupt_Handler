module timer(input pclk,
	     input preset_n,
	     input psel,
	     input pwrite,
	     input penable,
	     input [7:0] pwdata,
	     input [7:0] paddr,
	     output [7:0] prdata,
	     output pready,
	     output pslverr
	     ,output ovf_flag,
	     output udf_flag
	     );

// khai bao trung gian


//wire
wire en, load, updw;
wire [1:0] cks;
wire [1:0] clr_flag;
wire clk_int;
wire ovf_flag, udf_flag;
wire [7:0] tdr, last_cnt, cnt;
//clock select

clk_sel sys_clk (.pclk(pclk),
		 .preset_n(preset_n),
		 .cks(cks),
		 .clk_int(clk_int)
		 );

//counter

counter counter_module (.pclk(pclk),
			.preset_n(preset_n),
			.load(load),
			.en(en),
			.updw(updw),
			.tdr(tdr),
			.clk_int(clk_int),
			.cnt(cnt),
			.last_cnt(last_cnt)
			);

//compare

compare compare_module (.pclk(pclk),
			.preset_n(preset_n),
			.trig_clr(clr_flag),
			.last_cnt(last_cnt),
			.cnt(cnt),
			.en(en),
			.load(load),
			.updw(updw),
			.ovf_trig(ovf_flag),
			.udf_trig(udf_flag)
			);

//write read control
rw_control reg_control (.pclk(pclk),
			.preset_n(preset_n),
			.psel(psel),
			.pwrite(pwrite),
			.penable(penable),
			.ovf_trig(ovf_flag),
			.udf_trig(udf_flag),
			.paddr(paddr),
			.pwdata(pwdata),
			.prdata(prdata),
			.pready(pready),
			.pslverr(pslverr),
			.en(en),
			.load(load),
			.updw(updw),
			.tdr(tdr),
			.clr_trig(clr_flag),
			.cks(cks)
			);


endmodule
