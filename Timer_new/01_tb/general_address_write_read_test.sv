module general_address_write_read_test;
reg [7:0] address, wdata, rdata;
reg fail, err;
integer a = 0;

testbench top();

initial begin
   $display("========================================================");
   $display("============= ALL ADDRESS WRITE TEST BEGIN =============");
   $display("========================================================");
   repeat (20) begin
      #100;
      a=a+1;
      $display("TEST NO. %3d\n",a);
      wdata = $random;
      address = $urandom_range(0,2);
      if (address == 8'h00) begin
        $display("======== TEST TDR REGISTER =======");
        top.cpu.write_data(8'h00, wdata, err);
        top.cpu.read_data(8'h00, rdata, err);
        if (rdata == wdata) begin
          $display("At %0t, wdata=8'h%0h matched rdata=8'h%0h --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, wdata=8'h%0h mismatched rdata=8'h%0h --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      else if (address == 8'h01) begin
        $display("======== TEST TCR REGISTER ======="); 
        top.cpu.write_data(8'h01, wdata, err);
        top.cpu.read_data(8'h01, rdata, err);
        if ((rdata[7] == wdata[7]) && (rdata[5:4] == wdata[5:4]) && (rdata[1:0] == wdata[1:0])) begin
          $display("At %0t, wdata=8'h%0h, rdata=8'h%0h --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, wdata=8'h%0h, rdata=8'h%0h --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      else if (address == 8'h02) begin
        $display("======== TEST TSR REGISTER =======");
        top.cpu.write_data(8'h02, wdata, err);
        top.cpu.read_data(8'h02, rdata, err);
        if (rdata == 8'h00) begin
          $display("At %0t, wdata=8'h%0h matched rdata=8'h%0h --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, wdata=8'h%0h mismatched rdata=8'h%0h --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      else begin
        $display("======== TEST NON-EXISTED REGISTER =======");
        top.cpu.write_data(address, wdata, err);
        top.cpu.read_data(address, wdata, err);
        if (top.dut.pslverr) begin
          $display("At %0t, no data in non-existed register --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, data was written in non_existed register --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      $display("---------------------------------------------\n");
   end
   repeat (80) begin
      #100;
      a=a+1;
      $display("TEST NO. %3d\n",a);
      wdata = $random;
      address = $random;
      if (address == 8'h00) begin
        $display("======== TEST TDR REGISTER =======");
        top.cpu.write_data(8'h00, wdata, err);
        top.cpu.read_data(8'h00, rdata, err);
        if (rdata == wdata) begin
          $display("At %0t, wdata=8'h%0h matched rdata=8'h%0h --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, wdata=8'h%0h mismatched rdata=8'h%0h --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      else if (address == 8'h01) begin
        $display("======== TEST TCR REGISTER ======="); 
        top.cpu.write_data(8'h01, wdata, err);
        top.cpu.read_data(8'h01, rdata, err);
        if ((rdata[7] == wdata[7]) && (rdata[5:4] == wdata[5:4]) && (rdata[1:0] == wdata[1:0])) begin
          $display("At %0t, wdata=8'h%0h, rdata=8'h%0h --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, wdata=8'h%0h, rdata=8'h%0h --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      else if (address == 8'h02) begin
        $display("======== TEST TSR REGISTER =======");
        top.cpu.write_data(8'h02, wdata, err);
        top.cpu.read_data(8'h02, wdata, err);
        if (rdata == 8'h00) begin
          $display("At %0t, wdata=8'h%0h matched rdata=8'h%0h --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, wdata=8'h%0h mismatched rdata=8'h%0h --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      else begin
        $display("======== TEST NON-EXISTED REGISTER =======");
        top.cpu.write_data(address, wdata, err);
        top.cpu.read_data(address, wdata, err);
        if (top.dut.pslverr) begin
          $display("At %0t, no data in non-existed register --PASS--\n", $time, wdata, rdata);
          fail = 1'b0;
        end
        else begin
          $display("At %0t, data was written in non_existed register --FAIL--\n", $time, wdata, rdata);
          fail = 1'b1;
        end
      end
      $display("---------------------------------------------\n");
   end
   #500;
   top.get_result(fail);
   $finish();
end
endmodule
