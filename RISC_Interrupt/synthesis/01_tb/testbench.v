//`timescale 1ns/10ps

module testbench;

  wire [3:0] out;
  wire Co;
  reg  clk,rstn,Cin;
  reg  [3:0] ina, inb;

  synth_wrapper full_adder (	.clk(clk),
	  			.rst_n(rstn),
				.S(out),
				.X(ina),
				.Y(inb),
				.Co(Co),
				.Cin(Cin)
			);

  initial begin
    $shm_open("waves.shm"); 
    $shm_probe("AS");
  end
  //initial begin
  //   $sdf_annotate("synth_wrapper.sdf",full_adder);
  //end

  initial begin
        #0 clk=1;
     forever #5 clk=~clk;
  end

  initial begin
        #0 rstn = 0;
        #10;  rstn = 1;
  end

  initial begin
     #0; 
     stimuli(4'h0,4'h0,1'b0);
     stimuli(4'h3,4'h2,1'b1);
     stimuli(4'h2,4'h9,1'b0);
     stimuli(4'h2,4'h3,1'b1);
     #200;
     $finish;
  end

  task stimuli(input [3:0] a,b, input cin);
     @(posedge clk) 
     {ina,inb,Cin} = {a,b,cin};#10;
  endtask

endmodule

