`timescale 1ns / 1ps

module TransdataEvenParity;

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

   // Internal variable to count txd changes
    integer count_data_trans;
    reg previous_txd; // To store the previous value of txd
	
	APB_UART_top apb (
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
    always @(posedge pclk or negedge presetn) begin
        if (~presetn) begin
          count_data_trans = 0; // Reset counter on reset
        end else if (apb.uart_tx.counter_next==0 & apb.uart_tx.counter==15) begin
          // Count the change in txd
          count_data_trans = count_data_trans + 1;
        end
      end
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
        count_data_trans = 0; 

		// Wait 100 ns for global reset to finish
		#20
		presetn = 1;
		#20
		//Set enbale signal 
		psel = 1;
		pwrite = 1;
		paddr = 32'h00000110;
		pwdata = 32'b01111111;
		#20;
		penable = 1; // ACCESS
		#20;

		psel = 0; //IDLE
		penable =0;
		#20;
		//Set baudrate
		psel = 1; //SET UP
		pwrite = 1;
		paddr = 32'h00000101;
		pwdata = 32'd27;
		#20;
		penable = 1; // ACCESS
		#20;
		
		psel=0;
		penable=0;
        #20;
		//Set data to transmiter
		psel = 1;
		pwrite = 1;
		paddr = 32'h00000100;
		pwdata = 32'b11011001;
		#20;
		penable = 1;
		#20;
		psel=0;
		penable=0;

		
        /*#20;
		//Set enbale signal
		psel = 1;
		pwrite = 1;
		paddr = 32'h00000110;
		pwdata = 32'b00000000;
		pstrb = 4'b1111;
		#20;
		penable = 1;
		#30;
		penable = 0;
        */
        #100000;
		$finish;

	end
	always begin
		pclk = ~pclk;
		#10;

		end
      
endmodule