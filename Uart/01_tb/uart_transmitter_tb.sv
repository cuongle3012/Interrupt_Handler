`timescale 1ps/1ps

module uart_transmitter_tb;

  // Inputs
  reg clk;
  reg bclk;
  reg resetn;
  reg [7:0] data_in;
  reg parity_en;
  reg parity_type;
  reg write_en;
  reg tx_en;
  reg [1:0] tx_thr_val;

  // Outputs
  wire txd;
  wire tx_bclk_en;
  wire tx_thr;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns clock period
  end

  initial begin
    bclk = 0;
    forever #1 bclk = ~bclk; // 40 ns baud clock
  end

  // Instantiate the UART Transmitter
  uart_transmitter uut (
    .clk(clk),
    .bclk(bclk),
    .resetn(resetn),
    .data_in(data_in),
    .parity_en(parity_en),
    .parity_type(parity_type),
    .write_en(write_en),
    .tx_en(tx_en),
    .tx_thr_val(tx_thr_val),
    .txd(txd),
    .tx_bclk_en(tx_bclk_en),
    .tx_thr(tx_thr)
  );

  // Test sequence
  initial begin
    // Initialize inputs
    resetn = 0;
    data_in = 8'b0;
    parity_en = 0;
    parity_type = 0;
    write_en = 0;
    tx_en = 0;

    // Reset pulse
    #20;
    resetn = 1;

    // Load data with parity enabled (even parity)
    #20;
    data_in = 8'b10100100; // Data to transmit
    parity_en = 1;
    parity_type = 0; // Even parity
    write_en = 1;
    tx_en = 1;

    #20;
    write_en = 0;

    #100;
    wait(tx_bclk_en == 2'b00);

    // Check results
    $display("Test with Even Parity");
    if (uut.data_temp == 9'b110100100) // Even parity bit = 1
      $display("PASS: Data transmitted with correct parity.");
    else
      $display("FAIL: Parity generation mismatch.");


    $stop;
  end

endmodule
