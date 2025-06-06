module clk2_countup_fake;

testbench top();

reg [7:0] wdata, rdata, address;
reg err;
reg result;

initial begin
  #200;
  $display("=========================================================");
  $display("================== CLK2_TEST_UP_FAKE ====================");
  $display("=========================================================");
  $display("-STEP1- \n");
  $display("At %0t, write data for TCR\n", $time);
  top.cpu.write_data(8'h00, 8'hff, err);	//nap gia tri cho TCNT truoc
  //0 gan TDR bang nhieu nghia la mac dinh =0

  top.cpu.read_data(8'h02, rdata, err);
  if (rdata !=0) top.cpu.write_data(8'h02, 8'h00, err);
  top.cpu.write_data(8'h01, 8'h80, err);        //nap gia tri cho TCNT truoc
  //top.cpu.write_data(8'h01, 8'h30, err);	//tat che do nap gia tri va kich hoat che do dem
  $display("---------------------------------------------------\n");
  //fork	//thuc hien 2 lenh //
  //begin
  $display("-STEP2- \n");
  $display("At %0t, load new value that can be overflowed\n", $time);
  repeat (2) @(posedge top.pclk);
  top.cpu.write_data(8'h00, 8'h00, err);
  top.cpu.write_data(8'h01, 8'h80, err);
  @(posedge top.pclk);
  $display("-STEP 3- \n");
  $display("At %0t, start counting and check udf whether overflowed \n", $time);
  top.cpu.write_data(8'h01, 8'h20, err);
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h01) begin
     $display("At %0t, TSR = 8'h%2h, OVERFLOW -FAIL- \n", $time, rdata);
     result = 1'b1;
  end
  else $display("At %0t, TSR = 8'h%2h, OVERFLOW -PASS-\n", $time, rdata);
  $display("-------------------------------------------------------\n");

  /*begin
    repeat (500) @(posedge top.pclk);
    $display("-STEP2.1-\n");
    $display("At %0t, wait 250 clk_int done\n", $time);
    $display("-STEP2.2-\n");
    $display("At %0t, after 250 clk_int, read_data TSR\n", $time);
    top.cpu.read_data(8'h02, rdata, err);
    if (rdata == 8'h00) $display("At %0t, TSR = 8'h%2h, NOT UNDERFLOW -PASS-\n", $time, rdata);
    else begin
    result = 1'b1;
    $display("At %0t, TSR = 8'h%2h. UNDERFLOW -FAIL-\n", $time, rdata);
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
  /*result = 1'b0;
  wdata = 8'h79;

  //ghi du lieu vao tdr de nap gia tri dem vao TCNT
  top.cpu.write_data(8'h00, wdata, err);
  #10;
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata != 8'h00) top.cpu.write_data(8'h02, 8'h00, err);	//rang ghi 0 vao thanh ghi tcr
  
  
  top.cpu.write_data(8'h01, 8'h80, err);	//nap load vao de bat dau nap gia tri dem vao TCNT
  #10;
  top.cpu.write_data(8'h01, 8'h30, err);	//enable=1, updw=1, cks=00;
  repeat (512) @(posedge top.system.pclk)
  top.cpu.read_data(8'h02, rdata, err);
  if (rdata == 8'h02) begin
  	$display("There is overflow --PASS--");
	result = 1'b0;
  end
  else begin
  	$display("No overflow --FAIL--");
	result = 1'b1;
  end*/
  $display("-----------------------------------------------\n");
  #500;
  top.get_result(result);
  $finish();
  end
endmodule

