module non_exist_write_read_test;
reg [7:0] address, wdata, rdata;
reg err, fail;
integer a = 0;
testbench top();

initial begin

$display("====================================================");
$display("========== NON-EXISTED WRITE TEST BEGIN ============");
$display("====================================================");

repeat (10) begin
#100;	
a=a+1;
$display("TEST NO. %3d\n", a);
wdata = $random();
address = $urandom_range(3,255);

top.cpu.write_data(address, wdata, err);
top.cpu.read_data(address, rdata, err);

if (top.dut.pslverr) begin
$display("NO DATA IN NON-EXISTED REGISTER --PASS--\n");
fail = 1'b0;
end
else begin
$display("ERROR FUNCTION --FAIL--\n");
fail = 1'b1;
end
$display("--------------------------\n");
end
#500;
top.get_result(fail);
$finish();
end
endmodule
