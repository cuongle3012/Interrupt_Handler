module clk2_countdown;

testbench top();

reg [7:0] wdata, rdata, address;
reg err;
reg result;

initial begin
  #200;
  $display("=========================================================");
  $display("==================== CLK2_TEST_DOWN =====================");
  $display("=========================================================");
  $display("-STEP1- \n");
  $display("At %0t, write data for TCR\n", $time);
  top.cpu.write_data(8'h00, 8'hff, err);	//nap gia tri cho TCNT truoc
  //0 gan TDR bang nhieu nghia la mac dinh =0

  top.cpu.read_data(8'h02, rdata, err);
  if (rdata !=0) top.cpu.write_data(8'h02, 8'h00, err);
  top.cpu.write_data(8'h01, 8'h80, err);        //nap gia tri cho TCNT truoc
  top.cpu.write_data(8'h01, 8'h30, err);	//tat che do nap gia tri va kich hoat che do dem
  $display("---------------------------------------------------\n");
  fork	//thuc hien 2 lenh //
  begin
  $display("-STEP2- \n");
  $display("At %0t, wait UDF\n", $time);
  repeat (512) @(posedge top.pclk);
  $display("-STEP3- \n");
  $display("At %0t, after 256 clk_int, read_data TSR\n", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h02) $display("At %0t, TSR = 8'h%2h, \033[34m-UNDERFLOW PASS-\033[0m \n", $time, rdata);  // Changed to blue
  else begin
    result = 1'b1;
    $display("At %0t, TSR = 8'h%2h, UNDERFLOW \033[31m-FAIL-\033[0m\n", $time, rdata);  // Changed to red for failure
  end
  $display("-------------------------------------------------------\n");
  end

  begin
    repeat (500) @(posedge top.pclk);
    //$display("-STEP2.1-\n");
    //$display("At %0t, wait 250 clk_int done\n", $time);
    //$display("-STEP2.2-\n");
    $display("At %0t, after 250 clk_int, read_data TSR\n", $time);
    top.cpu.read_data(8'h02, rdata, err);
    if (rdata == 8'h00) $display("At %0t, TSR = 8'h%2h, \033[34mNOT UNDERFLOW -PASS-\033[0m\n", $time, rdata);  // Changed to blue
    else begin
    result = 1'b1;
    $display("At %0t, TSR = 8'h%2h. UNDERFLOW \033[31m-FAIL-\033[0m\n", $time, rdata);  // Changed to red for failure
    end
    $display("-------------------------------------------------------\n");
  end
  join

  $display("-STEP4-\n");
  $display("At %0t, clear TSR\n", $time);
  top.cpu.write_data(8'h02, 8'h00, err);
  $display("-------------------------------------------------\n");
  $display("-STEP5-\n");
  $display("At %0t, read_data TSR\n", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h00) begin
     $display("At %0t, TSR = 8'h%2h \n", $time, rdata);
     $display("\033[34mBIT UNDERFLOW CLEAR -PASS-\033[0m \n");  // Changed to blue
  end
  else begin
     $display("At %0t, TSR = 8'h%2h \n", $time, rdata);
     $display("BIT UNDERFLOW NOT CLEAR \033[31m-FAIL-\033[0m \n");  // Changed to red for failure
  end

  $display("-----------------------------------------------\n");
  #500;
  top.get_result(result);
  $finish();
end
endmodule
