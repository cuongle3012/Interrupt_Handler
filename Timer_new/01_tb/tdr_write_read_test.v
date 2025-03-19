module tdr_write_read_test;
   reg [7:0] wdata, address, rdata;
   integer a = 0;
   reg fail = 1'b0;
   testbench top();
   reg err;
//Test process
initial begin
  #200;
  $display("========================================");
  $display("=========TDR WRITE TEST BEGIN===========");
  $display("========================================");
  repeat (10) begin
    a=a+1;
    $display("TEST NO.%3d\n", a);
  wdata = $random();
  top.cpu.write_data(8'h00, wdata, err);
    top.cpu.read_data(8'h00, rdata, err);

  
     if (rdata == wdata)
        $display("At time = %5d, rdata = 8'h%2h, wdata = 8'h%2h, --PASS-- \n", $time, rdata, wdata);
     else begin
        fail = 1'b1;
        $display("At time = %5d, rdata = 8'h%2h, wdata = 8'h%2h, --FAIL-- \n", $time, rdata, wdata);
	end
  $display("------------------------------------------\n");
  end
  #500;
  top.get_result(fail);
  $finish();
end
endmodule

