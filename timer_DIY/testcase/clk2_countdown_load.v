module clk2_countdown_load;

testbench top();

reg [7:0] wdata, rdata, address;
reg err;
reg [9:0] result;
reg [8:0] calc;
integer a=0;

initial begin
  repeat (10) begin
  a=a+1;
  $display("================= TEST NO.%3d =========================",a);
  #200;
  top.get_reset();
  result[a-1] = 1'b0;
  $display("=========================================================");
  $display("================= CLK2_TEST_DOWN_LOAD ===================");
  $display("=========================================================");
  $display("-STEP1- \n");
  $display("At %0t, write data for TCR\n", $time);
  top.cpu.write_data(8'h00, 8'h63, err);	//nap gia tri cho TCNT truoc
  //0 gan TDR bang nhieu nghia la mac dinh =0

  top.cpu.read_data(8'h02, rdata, err);
  if (rdata !=0) top.cpu.write_data(8'h02, 8'h00, err);
  top.cpu.write_data(8'h01, 8'h80, err);        //nap gia tri cho TCNT truoc
  top.cpu.write_data(8'h01, 8'h30, err);	//tat che do nap gia tri va kich hoat che do dem	//dieu chinh xung clk_int o day
  $display("---------------------------------------------------\n");
  $display("-STEP2- \n");
  $display("At %0t, wait UDF\n", $time);
  repeat (150) @(posedge top.pclk);
  $display("-STEP3- \n");
  $display("At %0t, start loading new value for TCNT\n", $time);
  //fork	//thuc hien 2 lenh //
  //begin
  wdata = $urandom_range(0,8'hff);
  if (wdata > 8'd25)
  top.cpu.write_data(8'h00, wdata, err);	//nap gia tri moi cho TDR
  top.cpu.write_data(8'h01, 8'h80, err);	//tat dem va nap gia tri vao TCNT	//dieu chinh xung clk_int o day
  top.cpu.write_data(8'h01, 8'h30, err);	//dem lai		//dieu chinh xung clk_int o day
  $display("-STEP 3.1-\n");
  $display("Continue counting after loading new value then wait for the last time and check whether TCNT was loaded new value\n");
  repeat (50) @(posedge top.pclk);	//wait for the last time that would be overflowed
  top.cpu.read_data(8'h02, rdata, err);
  if (!rdata) $display("At %0t, completed check, the new value doesn't make TCNT underflowed -PASS-", $time);
  else begin
     result[a-1] = 1'b1;
     $display("At %0t, Wrong design -FAIL-", $time);
  end
  calc = wdata + wdata - 50;
  repeat (calc) @(posedge top.pclk);
  $display("At %0t, after enough clk_int according to the calculation, read_data TSR\n", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h02) $display("At %0t, TSR = 8'h%2h, UNDERFLOW -PASS- \n", $time, rdata);
  else begin
    result[a-1] = 1'b1;
    $display("At %0t, TSR = 8'h%2h, UNDERFLOW -FAIL-\n", $time, rdata);
  end
  $display("-------------------------------------------------------\n");
  //end*/

  //begin
    top.cpu.write_data(8'h00, 8'h10, err);	//nap gia tri moi cho TDR
    top.cpu.write_data(8'h01, 8'h80, err);	//tat dem va nap gia tri vao TCNT	dieu chinh xung clk_int o day
    top.cpu.write_data(8'h01, 8'h30, err);	//dem lai	//dieu chinh xung clk_int o day
    $display("-STEP 3.2-\n");
    $display("Continue counting after loading new value then wait for the last time and check whether TCNT was loaded new value\n");
    repeat (50) @(posedge top.pclk);	//wait for the last time that would be overflowed
    top.cpu.read_data(8'h02, rdata, err);
    if (rdata == 8'h02) $display("At %0t, completed check, the new value makes TCNT underflowed -PASS-", $time);
    else begin
       result[a-1] = 1'b1;
       $display("At %0t, Wrong design -FAIL-", $time);
    end
    $display("-------------------------------------------------------\n");
  //end
  //join

  $display("-STEP4-\n");
  $display("At %0t, clear TSR\n", $time);
  top.cpu.write_data(8'h02, 8'h00, err);
  $display("-------------------------------------------------\n");
  $display("-STEP5-\n");
  $display("At %0t, read_data TSR\n", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h00) begin
     $display("At %0t, TSR = 8'h%2h \n", $time, rdata);
     $display("BIT UNDERFLOW CLEAR -PASS- \n");
  end
  else begin
     $display("At %0t, TSR = 8'h%2h \n", $time, rdata);
     $display("BIT UNDERFLOW NOT CLEAR -FAIL- \n");
  end
  $display("-----------------------------------------------\n");
  #500;
  end
  top.get_result(|result);
  $finish();
  end
endmodule

