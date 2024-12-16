module clk_test;
reg pclk, preset_n;
reg [1:0] cks;
reg clk_int;
integer a = 0;
integer t1, t2;
reg fail;
testbench top();

initial begin
#200;
$display("==========================================");
$display("=============== CLK TEST =================");
$display("==========================================");

repeat (20) begin
  a=a+1;
  $display("TEST NO.%3d\n", a);
  cks = $urandom_range(0,3);
  if (cks == 2'b00) begin
     @(posedge top.clk_sel.clk2) t1=$time;
     @(posedge top.clk_sel.clk2) t2=$time;
     if (t2 - t1 == 40) begin
        $display("PCLK2 ACTIVE CORRECTLY --PASS--");
        fail=1'b0;
     end
     else begin
        $display("PCLK2 ACTIVE INCORRECTLY --FAIL--");
        fail=1'b1;
     end
  end
  if (cks == 2'b01) begin
     @(posedge top.clk_sel.clk4) t1=$time;
     @(posedge top.clk_sel.clk4) t2=$time;
     if (t2 - t1 == 80) begin
        $display("PCLK4 ACTIVE CORRECTLY --PASS--");
        fail=1'b0;
     end
     else begin
        $display("PCLK4 ACTIVE INCORRECTLY --FAIL--");
        fail=1'b1;
     end
  end
  if (cks == 2'b10) begin
     @(posedge top.clk_sel.clk8) t1=$time;
     @(posedge top.clk_sel.clk8) t2=$time;
     if (t2 - t1 == 160) begin
        $display("PCLK8 ACTIVE CORRECTLY --PASS--");
        fail=1'b0;
     end
     else begin
        $display("PCLK8 ACTIVE INCORRECTLY --FAIL--");
        fail=1'b1;
     end
  end
  if (cks == 2'b11) begin
     @(posedge top.clk_sel.clk16) t1=$time;
     @(posedge top.clk_sel.clk16) t2=$time;
     if (t2 - t1 == 320) begin
        $display("PCLK16 ACTIVE CORRECTLY --PASS--");
        fail=1'b0;
     end
     else begin
        $display("PCLK16 ACTIVE INCORRECTLY --FAIL--");
        fail=1'b1;
     end
  end
  $display("------------------------------------\n");
  end
  #500;
  top.get_result(fail);
  $finish();
end
endmodule
 
