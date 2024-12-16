module cpu_model (input pclk,
		  input preset_n,
		  input pslverr,
		  input pready,
		  input [7:0] prdata,
		  output reg pwrite,
		  output reg psel,
		  output reg penable,
		  output reg [7:0] paddr,
		  output reg [7:0] pwdata,
		  output reg NMI,
		  output reg [7:0] IRQ,
		  output reg [7:0] Int_IRQ,
		  output reg i_bit,
		  output reg I_flag,
		  output reg UI_flag
		  );

initial begin
pwrite = 1'b0;
psel = 1'b0;
penable = 1'b0;
paddr = 8'h00;
pwdata = 8'h00;
end

always @(posedge pclk or negedge preset_n) begin	//0 can bat xung pclk
if (!preset_n) begin
	   pwrite = 1'b0;
	   psel = 1'b0;
	   penable = 1'b0;
	   paddr = 1'b0;
	   pwdata = 1'b0;
	end
	else begin
	   pwrite = pwrite;
	   psel = psel;
	   penable = penable;
	   paddr = paddr;
	   pwdata = pwdata;
	end
end

task write_data (input [7:0] address, input [7:0] data, output err);
begin
	@(posedge pclk);
	#1;
	pwrite = 1'b1;
	psel = 1'b1;
	paddr = address;
	pwdata = data;
	$display("At %0t start writing wdata='h0%0h to address = 8'h%0h", $time, data, address);

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
	paddr = 8'h00;
	pwdata = 8'h00;
	penable = 1'b0;
	$display("At %0t write transfer completed", $time);
end
endtask

task read_data (input [7:0] address, output [7:0] data, output err);
begin
	@(posedge pclk);
	#1;
	pwrite = 1'b0;
	psel = 1'b1;
	paddr = address;
	$display("At %0t start reading from address=8'h%0h", $time, address);

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
	paddr = 8'h00;
	penable = 1'b0;
	$display("At %0t read transfer completed", $time);

end
endtask

task psel_control_on(input integer t);		//?
	begin
		$display("ASSERT psel for %0d cycles", t);
		repeat (t) begin
			psel = 1'b1;
			@(posedge pclk);
		end
	end
endtask

task psel_control_off(input integer t);		//?
	begin
		$display("DEASSERT psel for %0d cycles", t);
		repeat (t) begin
			psel = 1'b0;
			@(posedge pclk);
		end
	end
endtask

task intr_trigger_on_off(input [16:0] intr_sign, input mask);
	begin
		{NMI,IRQ,Int_IRQ} = intr_sign;
		
		case (NMI)
				1'b1: $display("at time %t -----------> TRIGGER NMI", $time);
				1'b0: $display("de-triggered NMI");
				default: $display("no stimulus applied on NMI");
		endcase
		for (int i=7;i>=0;i=i-1) begin
			case (IRQ[i])
				1'b1: $display("at time %t -----------> TRIGGER BIT NO.%0d EXTERNAL INTERRUPT", $time, i);
				1'b0: $display("de-triggered BIT NO.%0d EXTERNAL INTERRUPT",i);
				default: $display("no stimulus applied on EXTERNAL INTERRUPT");
			endcase
		end
		for(int i=7;i>=0;i=i-1) begin
			case (Int_IRQ[i])
				1'b1: $display("at time %t -----------> TRIGGER BIT NO.%0d INTERNAL INTERRUPT", $time, i);
				1'b0: $display("de-triggered BIT NO.%0d INTERNAL INTERRUPT", i);
				default: $display("no stimulus applied on INTERNAL INTERRUPT");
			endcase
		end

		i_bit = mask;		//?
		case (i_bit)
			1'b0: $display("unmask");
			1'b1: $display("mask");
			default: $display("no stimulus applied on mask");
		endcase
	end
endtask

task I_UI_flag(output I_flag, output UI_flag);
	begin
		case (I_flag)
			1'b0: $display("no I_flag has been setup");
			1'b1: $display("I_flag has been setup");
			default: $display("no stimulus applied on I_flag");
		endcase

		case (UI_flag)
			1'b0: $display("no UI_flag has been setup");
			1'b1: $display("UI_flag has been setup");
			default: $display("no stimulus applied on UI_flag");
		endcase
	end
endtask

endmodule
