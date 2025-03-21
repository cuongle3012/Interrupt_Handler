module clk2_countup;

testbench top();

reg [7:0] wdata, rdata, address;
reg err;
reg result;

initial begin
  #200;
  $display("=========================================================");
  $display("====================== CLK2_TEST_UP =====================");
  $display("=========================================================");
  $display("-STEP1- \n");
  $display("At %0t, write data for TCR", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata != 0) top.cpu.write_data(8'h02, 8'h00, err);
  top.cpu.write_data(8'h01, 8'h80, err);      
  top.cpu.write_data(8'h01, 8'h10, err);	//
  $display("---------------------------------------------------");
  fork	
  begin
    $display("-STEP2- \n");
    $display("At %0t, wait UDF", $time);
    repeat (512) @(posedge top.pclk);
    $display("-STEP3- \n");
    $display("At %0t, after 256 clk_int, read_data TSR", $time);
    top.cpu.read_data(8'h02, rdata, err);
    if (rdata == 8'h01)
      $display("At %0t, TSR = 8'h%2h, \033[34mOVERFLOW -PASS-\033[0m \n", $time, rdata);
    else begin
      result = 1'b1;
      $display("At %0t, TSR = 8'h%2h, \033[31mOVERFLOW -FAIL-\033[0m\n", $time, rdata);
    end
    $display("-------------------------------------------------------");
  end

  begin
    repeat (500) @(posedge top.pclk);
   // $display("-STEP2.1-\n");
    //$display("At %0t, wait 250 clk_int done", $time);
    //$display("-STEP2.2-\n");
    $display("At %0t, after 250 clk_int, read_data TSR", $time);
    top.cpu.read_data(8'h02, rdata, err);
    if (rdata == 8'h00)
      $display("At %0t, TSR = 8'h%2h, \033[34mNOT OVERFLOW -PASS-\033[0m", $time, rdata);
    else begin
      result = 1'b1;
      $display("At %0t, TSR = 8'h%2h, \033[31mOVERFLOW -FAIL-\033[0m\n", $time, rdata);
    end
    $display("-------------------------------------------------------");
  end
  join

  $display("-STEP4-\n");
  $display("At %0t, clear TSR", $time);
  top.cpu.write_data(8'h02, 8'h00, err);
  $display("-------------------------------------------------");
  $display("-STEP5-\n");
  $display("At %0t, read_data TSR", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h00) begin
     $display("At %0t, TSR = 8'h%2h ", $time, rdata);
     $display("\033[34mBIT OVERFLOW CLEAR -PASS-\033[0m ");
  end
  else begin
     $display("At %0t, TSR = 8'h%2h ", $time, rdata);
     $display("\033[31mBIT OVERFLOW NOT CLEAR -FAIL-\033[0m ");
     result = 1'b1;
  end
  $display("-----------------------------------------------");
  #500;
  top.get_result(result);
  $finish();
end

endmodule
