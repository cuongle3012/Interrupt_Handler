module tb;

   logic pclk;
   logic preset_n;
   logic pwrite;
   logic penable;
   logic psel;
   logic [31:0] pwdata;
   logic [31:0] prdata;
   logic [31:0] paddr;
   logic pready;
   logic pslverr;
   logic err;
   logic result;

   timer dut(.*);

   logic [31:0] rdata;
   assign rdata = dut.prdata;

   task get_result(input reg a);
      begin
            if (a) begin
               $display("======================================================");
               $display("\033[31m============ TEST FAILED ==========\033[0m"); 
               $display("========================================================");
            end
            else begin
               $display("===================================================");
               $display("\033[31m=================== TEST PASSED ===================\033[0m"); 
               $display("===================================================");
            end
      end
   endtask

   task write_data (input [31:0] address, input [31:0] data, output err);
      begin
         @(posedge pclk);
         pwrite = 1'b1;
         psel = 1'b1;
         paddr = address;
         pwdata = data;
        // $display("At %0t start writing wdata='h0%0h to address = 32'h%0h", $time, data, address);

         @(posedge pclk);
         penable = 1'b1;

        //  @(posedge pclk);
         while (!pready) @(posedge pclk);
         if (pslverr) begin
        // $display("At %0t address ('h%0h) no-existed -- Error address", $time, address);
         err = pslverr;
         err = 1'b0;
         end
         @(posedge pclk);
         pwrite = 1'b0;
         psel = 1'b0;
        //  paddr = 32'h00;
        //  pwdata = 32'h00;
         penable = 1'b0;
        // $display("At %0t write transfer completed", $time);
      end
   endtask

   task read_data (input [31:0] address, output [31:0] data, output err);
      begin
         @(posedge pclk);
         pwrite = 1'b0;
         psel = 1'b1;
         paddr = address;
         //$display("At %0t start reading from address=8'h%0h", $time, address);

         @(posedge pclk);
         penable = 1'b1;

         // @(posedge pclk);
         while (!pready) @(posedge pclk);
         data = rdata;
         if (pslverr) begin
         //$display("At %0t address ('h%0h) no-existed -- Error address", $time, address);
         err = pslverr;
         err = 1'b0;
         end
         @(posedge pclk);
         pwrite = 1'b0;
         psel = 1'b0;
        //  paddr = 32'h00;
         penable = 1'b0;
        // $display("At %0t read transfer completed", $time);

      end
   endtask

   initial begin
      #200;
      $display("==================================================");
      $display("=============== CLK2_TEST_DOWN ===================");
      $display("==================================================");
      $display(" -STEP 1- ");
      $display(" At %0t, write data for TCR", $time);
      paddr = 32'h0;
      pwdata = 32'hFF;
      write_data(paddr, pwdata, err); // Nạp giá trị cho TCNT trước
      paddr = 32'h8;
      read_data(paddr, prdata, err);
      if (prdata != 0) write_data(paddr, 32'h00000003, err);  //xóa cờ
      pwdata = 32'h80;
      paddr = 32'h4;
      write_data(paddr, pwdata, err); // Nạp giá trị cho TCR
      pwdata = 32'h30;
      write_data(paddr, pwdata, err); // Tắt chế độ nạp giá trị và kích hoạt chế độ đếm
      $display("---------------------------------------------------");
      fork // Thực hiện 2 lệnh đồng thời
      begin
        //$display(" -STEP2- ");
        //$display(" At %0t, wait UDF", $time);
        repeat (512) @(posedge pclk);
        $display(" -STEP 2.2- ");
        $display(" At %0t, after 256 clk_int, read_data TSR", $time);
        paddr = 32'h8;
        read_data(paddr, prdata, err);
        if (prdata == 32'h00000002) 
          $display(" At %0t, TSR = 32'h%0h, \033[34mUNDERFLOW -PASS-\033[0m ", $time, prdata);
        else begin
          result = 1'b1;
          $display(" At %0t, TSR = 32'h%0h, UNDERFLOW \033[31m-FAIL-\033[0m", $time, prdata);
        end
        $display("---------------------------------------------------");
      end
    
      begin
        repeat (500) @(posedge pclk);
        $display(" -STEP 2.1- ");
        $display(" At %0t, after 250 clk_int, read_data TSR", $time);
        paddr = 32'h8;
        read_data(paddr, prdata, err);
        if (prdata == 32'h00000000) 
          $display(" At %0t, TSR = 32'h%0h, \033[34mNOT UNDERFLOW -PASS-\033[0m", $time, prdata);
        else begin
          result = 1'b1;
          $display(" At %0t, TSR = 32'h%0h. UNDERFLOW \033[31m-FAIL-\033[0m", $time, prdata);
        end
        $display("---------------------------------------------------");
      end
      join
      $display(" -STEP 3-");
      $display(" At %0t, clear TSR", $time);
      paddr = 32'h00000008;
      pwdata = 32'h00000000;   //xóa trạng thái tsr
      preset_n = 1'b0;
      write_data(paddr, pwdata, err);
      $display("--------------------------------------------------");
      $display(" -STEP 4-");
      
      $display(" At %0t, read_data TSR", $time);
      read_data(paddr, prdata, err);
      if (prdata == 32'h00000000) begin
        $display(" At %0t, TSR = 32'h%0h. \033[34mBIT UNDERFLOW CLEAR -PASS-\033[0m ", $time, prdata);
      end
      else begin
        $display("At %0t, TSR = 32'h%0h. \033[34mBIT UNDERFLOW NOT CLEAR -FAIL-\033[0m  ", $time, prdata);
      end
    
      $display("---------------------------------------------------");
      #5000;
      get_result(result);
      $finish();
    end

    initial begin
      pclk = 1'b0;
      preset_n = 1'b1;
      #10;
      preset_n = 1'b0;
      #50;
      preset_n = 1'b1;
    end

    always #10 pclk=~pclk;
endmodule