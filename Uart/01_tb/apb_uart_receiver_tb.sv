`timescale 1ns / 1ps
`define CLK @(posedge pclk)

module ReceivedataEvenParity;

	// Inputs
	reg pclk;
	reg presetn;
	reg psel;
	reg [31:0] paddr;
	reg penable;
	reg pwrite;
	reg [31:0] pwdata;
	reg rxd;

	// Outputs
	wire pready;
	wire pslverr;
	wire [31:0] prdata;
	wire txd;
	wire totalint;
	wire itx_thr;
	wire irx_thr;
	wire irx_ov;
	wire i_pe;
	wire i_fre;

	// Instantiate the Unit Under Test (UUT)
	APB_UART_top uut (
		.pclk(pclk), 
		.presetn(presetn), 
		.psel(psel), 
		.paddr(paddr), 
		.penable(penable), 
		.pwrite(pwrite), 
		.pwdata(pwdata), 
		.rxd(rxd), 
		.pready(pready), 
		.pslverr(pslverr), 
		.prdata(prdata), 
		.txd(txd), 
		.totalint(totalint), 
		.itx_thr(itx_thr), 
		.irx_thr(irx_thr), 
		.irx_ov(irx_ov), 
		.i_pe(i_pe), 
		.i_fre(i_fre)
	);

initial begin
//Task 1: Write 1 data and transfer by receiver
		// Initialize Inputs
		pclk = 0;
		presetn = 0;
		psel = 0;
		paddr = 0;
		penable = 0;
		pwrite = 0;
		pwdata = 0;
		
	

		#20;
		presetn = 1;
		#20;
		
		//Set enbale signal
		psel = 1;
		pwrite = 1;
	    paddr = 32'h00000110;;
		pwdata = 32'b01111111;
	
		#20;
		penable = 1;
		#20;
		penable = 0;
		//Set baudrate
		psel = 1;
		pwrite = 1;
		paddr = 32'h00000101;
		pwdata = 32'd27;
		#20;
		penable = 1;
		#20;
		penable = 0;
		psel = 0;
		#20;
		//Set data to receive
		// Formula: 16*div_val=16*27=432
		//Start bit
		rxd = 0;
		repeat (432) `CLK;
		//Bit 0
		rxd = 1;
		repeat (432) `CLK;
		//Bit 1
		rxd = 0;
		repeat (432) `CLK;
		//Bit 2
		rxd = 0;
	    repeat (432) `CLK;
		//Bit 3
		rxd = 1;
		repeat (432) `CLK;
		//Bit 4
		rxd = 1;
		repeat (432) `CLK;
		//Bit 5
		rxd = 0;
		repeat (432) `CLK;
		//Bit 6
		rxd = 1;
		repeat (432) `CLK;
		//Bit 7
		rxd = 1;
		repeat (432) `CLK;
		//Parity bit
		rxd = 1; //No error
	//	rxd = 0; //Error
		repeat (432) `CLK;
		//Stop bit
		rxd = 1;
		repeat (432) `CLK;
		
		//Read data
		psel = 1;
		pwrite = 0;
		paddr =  32'h00000100;
		#20;
		penable = 1;
		#60;
		penable = 0;
		psel = 0;
		#100000;
		$finish;

	end
	always begin
		pclk = ~pclk;
		#10;
		end
      
      
endmodule