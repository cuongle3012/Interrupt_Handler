module tcr_write_read_test;

reg [7:0] address, wdata, rdata;
reg err;
integer a = 0;
reg fail;


testbench top();

initial begin
#200;
$display("==================================================");
$display("============= TCR WRITE TEST BEGIN ===============");
$display("==================================================");

repeat (10) begin
a = a + 1;
$display("TEST NO.%3d\n", a);
wdata = $random;
top.cpu.write_data(8'h01, wdata, err);
top.cpu.read_data(8'h01, rdata, err);
if ((rdata[7] == wdata[7]) && (rdata[5:4] == wdata[5:4]) && (rdata[1:0] == wdata[1:0])) begin
$display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --PASS--", $time, wdata, rdata);
fail = 1'b0;
end
else begin
$display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --FAIL--", $time, wdata, rdata);
fail = 1'b1;
end
$display("---------------------------------------------");
end

#500;
top.get_result(fail);
$finish();
end

endmodule
