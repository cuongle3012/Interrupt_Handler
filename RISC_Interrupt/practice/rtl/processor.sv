module processor(input i_clk,
                  input i_rst_n,
                  input e_irq,
                  input [31:0] i_io_sw,
                  input [3:0] i_io_btn,
                  output [31:0] o_io_ledr, o_io_ledg,
                  output [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
                  output [31:0] o_io_lcd
                  );

   logic pready_tmr, pready;
   logic t_irq;

   logic [31:0] prdata_timer, prdata_uart, prdata_plic, pwdata, paddr;
   logic psel_timer, psel_uart, psel_plic, penable, pwrite;

   assign pready = pready_tmr;

   pipelined CPU(.i_clk(i_clk),
                  .i_rst_n(i_rst_n),
                  .e_irq(e_irq),
                  .t_irq(t_irq),
                  .o_io_ledr(o_io_ledr),
                  .o_io_ledg(o_io_ledg),
                  .o_io_hex0(o_io_hex0),
                  .o_io_hex1(o_io_hex1),
                  .o_io_hex2(o_io_hex2),
                  .o_io_hex3(o_io_hex3),
                  .o_io_hex4(o_io_hex4),
                  .o_io_hex5(o_io_hex5),
                  .o_io_hex6(o_io_hex6),
                  .o_io_hex7(o_io_hex7),
                  .o_io_lcd(o_io_lcd),
                  .i_io_sw(i_io_sw),
                  .i_io_btn(i_io_btn),
                  .pready(pready),
                  .prdata_timer(prdata_timer),
                  .prdata_uart(prdata_uart),
                  .prdata_plic(prdata_plic),
                  .psel_timer(psel_timer),
                  .psel_uart(psel_uart),
                  .psel_plic(psel_plic),
                  .penable(penable),
                  .pwrite(pwrite),
                  .paddr(paddr),
                  .pwdata(pwdata));


   timer timer(.pclk(i_clk),
                  .preset_n(i_rst_n),
                  .psel(psel_timer),
                  .pwrite(pwrite),
                  .penable(penable),
                  .pwdata(pwdata),
                  .paddr(paddr),
                  .prdata(prdata_timer),
                  .pready(pready_tmr),
                  .pslverr(),
                  .intr_timer(t_irq));

   
endmodule