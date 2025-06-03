module processor_tb;
   logic i_clk;
   logic i_rst_n;
   logic e_irq;
   logic [31:0] o_io_ledr, o_io_ledg;
   logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7;
   logic [31:0] o_io_lcd;
   logic [31:0] i_io_sw;
   logic [3:0] i_io_btn;

   processor tb(.*);

   initial begin
      i_clk = 1'b0;
      i_rst_n = 1'b0;
      e_irq = 1'b0;
      #10;
      i_rst_n = 1'b1;
      #50000;
      $finish;
   end

   always #5 i_clk=~i_clk;
   
endmodule
