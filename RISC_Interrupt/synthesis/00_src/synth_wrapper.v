module synth_wrapper
(
 input wire [3:0] X, Y,// Two 4-bit inputs
 input wire rst_n,clk,
 output reg [3:0] S,
 input wire Cin,
 output reg Co  
);
  reg [3:0] X_reg;
  reg [3:0] Y_reg;
  reg [3:0] S_reg;
  wire  Co_reg;
  reg  Cin_reg;

 always@(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
       X_reg <= 4'h0;
       Y_reg <= 4'h0;
       S <= 4'h0;
       Co <= 1'b0;
       Cin_reg <= 1'h0;
    end
    else begin
       X_reg <= X;
       Y_reg <= Y;
       S <= S_reg;
       Co <= Co_reg;
       Cin_reg <= Cin;
    end
 end
 
 ripple_adder u1(X_reg, Y_reg, S_reg, Co_reg, Cin_reg);

endmodule
