module clk2_countup_reset;

testbench top();

reg [7:0] wdata, rdata, address;
reg err;
reg result;

initial begin
  #200;
  $display("=========================================================");
  $display("=================== CLK2_TEST_UP_RESET ==================");
  $display("=========================================================");
  $display("-STEP1- \n");
  $display("At %0t, write data for TCR\n", $time);
  //top.cpu.write_data(8'h00, 8'hff, err);	//nap gia tri cho TCNT truoc
  //0 gan TDR bang nhieu nghia la mac dinh =0

  top.cpu.read_data(8'h02, rdata, err);
  if (rdata !=0) top.cpu.write_data(8'h02, 8'h00, err);
  top.cpu.write_data(8'h01, 8'h80, err);        //nap gia tri cho TCNT truoc
  top.cpu.write_data(8'h01, 8'h10, err);	//tat che do nap gia tri va kich hoat che do dem	//dieu chinh xung clk_int o day
  $display("---------------------------------------------------\n");
//  fork	//thuc hien 2 lenh //
//  begin
  $display("-STEP2- \n");
  $display("At %0t, wait OVF\n", $time);
  repeat (322) @(posedge top.pclk);
/*  $display("-STEP3- \n");
  $display("PAUSE TRIG ACTIVE \n");
  repeat (60) @(posedge top.pclk);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h00) $display("rdata = 8'h%0h, OVERFLOW DOESN'T HAPPEN -PASS-", rdata);
  else begin
     result = 1'b1;
     $display("rdata = 8'h%0h, THERE IS A MISTAKE IN PAUSE -FAIL-", rdata);
  end*/
  top.cpu.write_data(8'h01, 8'h00, err);		//dieu chinh xung clk_int o day
  $display("-STEP3.1- \n");
  $display("RESET TRIG ACTIVE \n");
  top.get_reset();
  top.cpu.read_data(8'h00, rdata, err);
  if (rdata == 8'h00) $display("COMPLETED CHECK TDR, tdr = 8'h%0h -PASS-", rdata);
  else begin
    $display("COMPLETED CHECK TDR, tdr = 8'h%0h -FAIL-", rdata);
    result = 1'b1;
  end
  top.cpu.read_data(8'h01, rdata, err);
  if (rdata == 8'h00) $display("COMPLETED CHECK TCR, tcr = 8'h%0h -PASS-", rdata);
  else begin
    $display("COMPLETED CHECK TCR, tcr = 8'h%0h -FAIL-", rdata);
    result = 1'b1;
  end
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h00) $display("COMPLETED CHECK TSR, tsr = 8'h%0h -PASS-", rdata);
  else begin
    $display("COMPLETED CHECK TSR, tsr = 8'h%0h -FAIL-", rdata);
    result = 1'b1;
  end
 
  if ((!top.test_cnt) && (!top.test_last_cnt)) $display("COMPLETED CHECK TCNT, cnt = 8'h%0h, last_cnt = 8'h%0h -PASS-", top.test_cnt, top.test_last_cnt);
  else begin
    $display("COMPLETED CHECK TCNT, cnt = 8'h%0h, last_cnt = 8'h%0h -FAIL-", top.test_cnt, top.test_last_cnt);
    result = 1'b1;
  end
  $display("-STEP 3.2- \n");
  $display("CONTINUE COUNTING \n");
  top.cpu.write_data(8'h01, 8'h10, err);	//dieu chinh xung clk_int o day
  repeat (300) @(posedge top.pclk);
  $display("At %0t, after 161 clk_int and pause, reset then continue counting the remain, read_data TSR\n", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (!rdata) $display("rdata = 8'h%0h, OVERFLOW DOESN'T HAPPEN -PASS-", rdata);
  else begin
     result = 1'b1;
     $display("rdata = 8'h%0h, THERE IS A MISTAKE IN RESET -FAIL-", rdata);
  end
  repeat (300) @(posedge top.pclk);
  $display("Continue counting and wait whether OVERFLOW happens\n");
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h01) $display("At %0t, TSR = 8'h%2h, OVERFLOW -PASS- \n", $time, rdata);
  else begin
    result = 1'b1;
    $display("At %0t, TSR = 8'h%2h, OVERFLOW -FAIL-\n", $time, rdata);
  end
  $display("-------------------------------------------------------\n");
//  end

/*  begin
    repeat (500) @(posedge top.pclk);
    $display("-STEP2.1-\n");
    $display("At %0t, wait 250 clk_int done\n", $time);
    $display("-STEP2.2-\n");
    $display("At %0t, after 250 clk_int, read_data TSR\n", $time);
    top.cpu.read_data(8'h02, rdata, err);
    if (rdata == 8'h00) $display("At %0t, TSR = 8'h%2h, NOT OVERFLOW -PASS-\n", $time, rdata);
    else begin
    result = 1'b1;
    $display("At %0t, TSR = 8'h%2h. OVERFLOW -FAIL-\n", $time, rdata);
    end
    $display("-------------------------------------------------------\n");
  end
  join*/

  $display("-STEP4-\n");
  $display("At %0t, clear TSR\n", $time);
  top.cpu.write_data(8'h02, 8'h00, err);
  $display("-------------------------------------------------\n");
  $display("-STEP5-\n");
  $display("At %0t, read_data TSR\n", $time);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h00) begin
     $display("At %0t, TSR = 8'h%2h \n", $time, rdata);
     $display("BIT OVERFLOW CLEAR -PASS- \n");
  end
  else begin
     $display("At %0t, TSR = 8'h%2h \n", $time, rdata);
     $display("BIT OVERFLOW NOT CLEAR -FAIL- \n");
  end
  $display("-----------------------------------------------\n");
  #500;
  top.get_result(result);
  $finish();
  end
endmodule

