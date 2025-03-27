module clk2_countdown;

  testbench top();
  
  reg [31:0] wdata, rdata, address;
  reg err;
  reg result;
  
  initial begin
    #200;
    $display("=========================================================");
    $display("==================== CLK2_TEST_DOWN =====================");
    $display("=========================================================");
    $display("-STEP1- \n");
    $display("At %0t, write data for TCR\n", $time);
    top.cpu.write_data(32'h00000000, 32'd255, err); // Nạp giá trị cho TCNT trước
  
    top.cpu.read_data(32'h00000008, rdata, err);
    if (rdata != 0) 
      top.cpu.write_data(32'h00000008, 32'h00000000, err);
  
    top.cpu.write_data(32'h00000004, 32'h00000080, err); // Nạp giá trị cho TCR
    top.cpu.write_data(32'h00000004, 32'h00000030, err); // Tắt chế độ nạp giá trị và kích hoạt chế độ đếm
    $display("---------------------------------------------------\n");
    fork // Thực hiện 2 lệnh đồng thời
    begin
      $display("-STEP2- \n");
      $display("At %0t, wait UDF\n", $time);
      repeat (512) @(posedge top.pclk);
      $display("-STEP3- \n");
      $display("At %0t, after 256 clk_int, read_data TSR\n", $time);
      top.cpu.read_data(32'h00000008, rdata, err);
      if (rdata == 32'h00000002) 
        $display("At %0t, TSR = 32'h%32h, \033[34m-UNDERFLOW PASS-\033[0m \n", $time, rdata);
      else begin
        result = 1'b1;
        $display("At %0t, TSR = 32'h%32h, UNDERFLOW \033[31m-FAIL-\033[0m\n", $time, rdata);
      end
      $display("-------------------------------------------------------\n");
    end
  
    begin
      repeat (500) @(posedge top.pclk);
      $display("At %0t, after 250 clk_int, read_data TSR\n", $time);
      top.cpu.read_data(32'h00000008, rdata, err);
      if (rdata == 32'h00000000) 
        $display("At %0t, TSR = 32'h%32h, \033[34mNOT UNDERFLOW -PASS-\033[0m\n", $time, rdata);
      else begin
        result = 1'b1;
        $display("At %0t, TSR = 32'h%32h. UNDERFLOW \033[31m-FAIL-\033[0m\n", $time, rdata);
      end
      $display("-------------------------------------------------------\n");
    end
    join
  
    $display("-STEP4-\n");
    $display("At %0t, clear TSR\n", $time);
    top.cpu.write_data(32'h00000008, 32'h0000000, err);
    $display("-------------------------------------------------\n");
    $display("-STEP5-\n");
    $display("At %0t, read_data TSR\n", $time);
    top.cpu.read_data(32'h000000008, rdata, err);
    if (rdata == 32'h00000000) begin
      $display("At %0t, TSR = 32'h%32h \n", $time, rdata);
      $display("\033[34mBIT UNDERFLOW CLEAR -PASS-\033[0m \n");
    end
    else begin
      $display("At %0t, TSR = 32'h%32h \n", $time, rdata);
      $display("BIT UNDERFLOW NOT CLEAR \033[31m-FAIL-\033[0m \n");
    end
  
    $display("-----------------------------------------------\n");
    #5000;
    top.get_result(result);
    $finish();
  end
  
  endmodule
  