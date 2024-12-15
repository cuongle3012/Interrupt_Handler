`timescale 1ps/1ps
`define CLK @(posedge clk)
module uart_receiver_tb;

  // Inputs
  reg clk;
  reg resetn;
  reg bclk;
  reg rxd;
  reg read_en;
  reg rx_en;
  reg parity_en;
  reg parity_type;
  reg [1:0] rx_thr_val;

  // Outputs
  wire [7:0] data_out;
  wire rx_bclk_en;
  wire rx_fre;
  wire rx_pe;
  wire rx_ov;
  wire rx_thr;

  // Clock generation
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
end

  initial begin
    bclk = 0;
    forever #1 bclk = ~bclk; // 40 ns baud clock
  end

  // Instantiate the UART Receiver
  uart_receiver uut (
    .clk(clk),
    .resetn(resetn),
    .bclk(bclk),
    .rxd(rxd),
    .read_en(read_en),
    .rx_en(rx_en),
    .parity_en(parity_en),
    .parity_type(parity_type),
    .rx_thr_val(rx_thr_val),
    .data_out(data_out),
    .rx_bclk_en(rx_bclk_en),
    .rx_fre(rx_fre),
    .rx_pe(rx_pe),
    .rx_ov(rx_ov),
    .rx_thr(rx_thr)
  );

  // Test sequence
  initial begin
    // Initialize inputs
    resetn = 0;
    rxd = 1; // Line is idle
    read_en = 0;
    rx_en = 1;
    parity_en = 1;    // Enable parity checking
    parity_type = 0;  // Even parity
    rx_thr_val = 2'b00; // Default threshold value

    // Reset pulse
    #20;
    resetn = 1;

    // Test case: Receive data with even parity
    // Transmit 8 data bits (10100100) with even parity bit (0)
    repeat (16) `CLK; rxd = 0; // Start bit
    repeat (16) `CLK; rxd = 1; // Data bit 0
    repeat (16) `CLK; rxd = 0; // Data bit 1
    repeat (16) `CLK; rxd = 1; // Data bit 2
    repeat (16) `CLK; rxd = 0; // Data bit 3
    repeat (16) `CLK; rxd = 1; // Data bit 4
    repeat (16) `CLK; rxd = 0; // Data bit 5
    repeat (16) `CLK; rxd = 1; // Data bit 6
    repeat (16) `CLK; rxd = 0; // Data bit 7
    repeat (16) `CLK; rxd = 0; // Parity bit
    repeat (16) `CLK; rxd = 1; // Stop bit


    // Wait for the data to be received
    repeat (16) `CLK; wait(rx_bclk_en == 2'b00);
    read_en = 1; // Read received data
   #320
    // Check received data
    if (data_out[7:0] == 8'b01010101)
      $display("PASS: Data received correctly.");
    else
      $display("FAIL: Data mismatch. Expected 8'b01010101, got %b", data_out[7:0]);

    // Check frame error and parity error
    if (rx_fre)
      $display("FAIL: Frame error detected.");
    else
      $display("PASS: No frame error.");

    if (rx_pe)
      $display("FAIL: Parity error detected.");
    else
      $display("PASS: No parity error.");

    $stop;
  end

endmodule
