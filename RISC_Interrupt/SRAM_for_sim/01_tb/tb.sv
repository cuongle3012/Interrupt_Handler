module processor_tb;
   logic i_clk;
   logic i_rst_n;
   logic [31:0] o_io_ledr, o_io_ledg;
   logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7;
   logic [31:0] o_io_lcd;
   logic [31:0] i_io_sw;
   logic [3:0] i_io_btn;

   processor tb(.*);

   initial begin
      i_clk = 1'b0;
      i_rst_n = 1'b0;
      #10;
      i_io_btn = 4'h0;
      i_io_sw = $urandom_range(0,65535);
      i_rst_n = 1'b1;
      #1000;
      i_io_btn = 4'h8;
      #35000;
      // i_io_btn = 4'b1000;
      // #50000;
      $finish;
   end

   always #5 i_clk=~i_clk;
   
endmodule
