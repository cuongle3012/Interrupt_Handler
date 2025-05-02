//clock gating
module counter (
    input pclk,
    input preset_n,
    input load,
    input en,
    input updown,
    input clk_int,
    input count_enable,
    input [31:0] tdr,
    output [31:0] cnt,
    output [31:0] last_cnt
);

  logic gated_clk;
  
  // Manual clock gating logic — replace with std cell if available
  logic clk_en_reg;
  always_comb begin
    clk_en_reg = en; // Gate enable condition
  end

  assign gated_clk = pclk & clk_en_reg; // Gated clock generation

  logic [31:0] cnt_reg;
  logic [31:0] last_cnt_reg;

  // Counter register with gated clock
  always @(posedge gated_clk or negedge preset_n) begin
    if (!preset_n) cnt_reg <= 32'd0;
    else if (load) cnt_reg <= tdr;
    else if (count_enable)
      cnt_reg <= updown ? cnt_reg - 1 : cnt_reg + 1;
  end

  assign cnt = cnt_reg;

  // Register to capture last count, still clocked by ungated clock
  always @(posedge pclk or negedge preset_n) begin
    if (!preset_n) last_cnt_reg <= 32'd0;
    else last_cnt_reg <= cnt_reg;
  end

  assign last_cnt = last_cnt_reg;

endmodule

// module counter (
//   input pclk,
//   input preset_n,
//   input load,
//   input en,
//   input updown,
//   input clk_int,
//   input count_enable,
//   input [31:0] tdr,
//   output [31:0] cnt,
//   output [31:0] last_cnt
// );

// logic [31:0] cnt_reg;
// logic [31:0] last_cnt_reg;

// // Counter register — no clock gating, always clocked by pclk
// always @(posedge pclk or negedge preset_n) begin
//   if (!preset_n)
//     cnt_reg <= 32'd0;
//   else if (en) begin
//     if (load)
//       cnt_reg <= tdr;
//     else if (count_enable)
//       cnt_reg <= updown ? cnt_reg - 1 : cnt_reg + 1;
//   end
// end

// assign cnt = cnt_reg;

// // Register to capture last count
// always @(posedge pclk or negedge preset_n) begin
//   if (!preset_n)
//     last_cnt_reg <= 32'd0;
//   else
//     last_cnt_reg <= cnt_reg;
// end

// assign last_cnt = last_cnt_reg;

// endmodule
