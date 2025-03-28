`timescale 1ns / 1ps


module ReceivedataEvenParity;

	// Inputs
	reg pclk;
	reg presetn;
	reg psel;
	reg [31:0] paddr;
	reg penable;
	reg pwrite;
	reg [31:0] pwdata;
	reg [2:0] pprot;
	reg [3:0] pstrb;
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
		.pprot(pprot), 
		.pstrb(pstrb), 
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
		pprot = 0;
		pstrb = 0;
		rxd = 1;

		// Wait 100 ns for global reset to finish
		#20;
		presetn = 1;
		#20;
		//Set enbale signal
		psel = 1;
		pwrite = 1;
	    paddr = 32'h00000110;;
		pwdata = 32'b11111111;
		pstrb = 4'b1111;
		#10;
		penable = 1;
		#30;
		penable = 0;
		//Set baudrate
		psel = 1;
		pwrite = 1;
		paddr = 32'h00000101;
		pwdata = 32'd14;
		pstrb = 4'b1111;
		#10;
		penable = 1;
		#30;
		penable = 0;
		psel = 0;
		#10;
		//Set data to receive
		//Start bit
		rxd = 0;
		#2240;
		//Bit 0
		rxd = 1;
		#2240;
		//Bit 1
		rxd = 1;
		#2240;
		//Bit 2
		rxd = 0;
		#2240;
		//Bit 3
		rxd = 1;
		#2240;
		//Bit 4
		rxd = 1;
		#2240;
		//Bit 5
		rxd = 0;
		#2240;
		//Bit 6
		rxd = 1;
		#2240;
		//Bit 7
		rxd = 1;
		#2240;
		//Parity bit
		rxd = 1; //No error
	//	rxd = 0; //Error
		#2240;
		//Stop bit
		rxd = 1;
		#2240;
		//Read data
		rxd = 1;
		psel = 1;
		pwrite = 0;
		paddr =  32'h00000100;
		pstrb = 4'b1111;
		#10;
		penable = 1;
		#30;
		penable = 0;
		psel = 0;
		#25000;
		$finish;

	end
	always begin
		pclk = ~pclk;
		#5;
		end
      
      
endmodule