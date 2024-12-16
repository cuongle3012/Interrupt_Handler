module ISR_check;

   testbench top();

   logic [7:0] data_in;
   logic [7:0] data_out;
   logic [7:0] address;
   logic [7:0] IRQ;
   logic [7:0] Int_IRQ;
   logic NMI;
   logic err;
   int count;
   logic fail;

   initial begin
      // #10;
      // top.preset_n = 1'b0;
      // #5;
      // top.preset_n = 1'b1;
      #50;
      $display("------------------- READ WRITE CHECK OF INTERRUPT STATUS REGISTERS ----------------------");
      repeat (5) begin
         $display("-----------------TEST NO.%0d---------------------", count);
         address = 8'h0B;
         data_in = $random;
         top.cpu.write_data(address, data_in, err);     //ghi data vào ISRA, ISRB xem đọc ra có giá trị?
         @(posedge top.pclk);
         top.cpu.read_data(address, data_out, err);     //đọc data ra coi thử nó có bằng 0?
         if (data_out == 8'h0) begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --PASS--", $time, data_in, data_out);
            fail = 1'b0;
         end
         else begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --FAIL--", $time, data_in, data_out);
            fail = 1'b1;
         end
         count++;
      end
      $display("==============================================================");
      repeat (5) begin
         $display("-----------------TEST NO.%0d---------------------", count);
         address = 8'h0C;
         data_in = $random;
         top.cpu.write_data(address, data_in, err);     //ghi data vào ISRA, ISRB xem đọc ra có giá trị?
         @(posedge top.pclk);
         top.cpu.read_data(address, data_out, err);     //đọc data ra coi thử nó có bằng 0?
         if (data_out == 8'h0) begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --PASS--", $time, data_in, data_out);
            fail = 1'b0;
         end
         else begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --FAIL--", $time, data_in, data_out);
            fail = 1'b1;
         end
         count++;
      end
      $display("==============================================================");
      repeat (5) begin
         $display("-----------------TEST NO.%0d---------------------", count);
         top.cpu.write_data(8'h09, 8'h55, err);     //ghi data config bắt cạnh xuống
         top.cpu.write_data(8'h0A, 8'h55, err);
         top.cpu.write_data(8'h00, 8'h23, err);    //tránh trường hợp bắt cạnh của NMI
         // top.cpu.write_data(8'h06, 8'hFF, err);   //enable toàn bộ
         // @(posedge top.pclk);
         top.cpu.write_data(8'h0C, 8'h03, err);       //xem xem khi ghi data vào nó có bị xóa status?
         if (data_out == 8'h30) begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --PASS--", $time, data_in, data_out);
            fail = 1'b0;
         end
         else begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --FAIL--", $time, data_in, data_out);
            fail = 1'b1;
         end
         fork
            begin
               repeat (2) @(posedge top.pclk);
               top.cpu.intr_trigger_on_off({9'b0,4'hF,4'h0}, 1'b0);
               // top.cpu.intr_trigger_on_off(17'b0, 1'b0);
               @(posedge top.pclk);
               top.cpu.intr_trigger_on_off({9'b0,2'b11,4'b00,2'b11},1'b0);
            end
         join_none
         top.cpu.write_data(8'h06, 8'hFF, err);   //enable toàn bộ, nhưng phải đúng thời điểm
         //signal luôn là cuối(intr luôn cuối)
         @(posedge top.pclk);
         // --> có vấn đề chỗ Int_IRQ_hit_r? có nên để datatype là bit?
         top.cpu.read_data(8'h0C, data_out, err);     //đọc data ra coi thử nó có bằng 0?
         if (data_out == 8'h30) begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --PASS--", $time, data_in, data_out);
            fail = 1'b0;
         end
         else begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --FAIL--", $time, data_in, data_out);
            fail = 1'b1;
         end
         count++;
      end
      $display("==============================================================");
      repeat (5) begin
         $display("-----------------TEST NO.%0d---------------------", count);
         top.cpu.write_data(8'h07, 8'hAA, err);     //ghi data config bắt cạnh lên
         top.cpu.write_data(8'h08, 8'hAA, err);
         top.cpu.write_data(8'h05, 8'hFF, err);   //enable toàn bộ
         @(posedge top.pclk);
         fork
            begin
               top.cpu.intr_trigger_on_off({9'b0,8'hFF}, 1'b0); //tại sao gán IRQ trực tiếp lại 0 dược?
               @(posedge top.pclk);
               top.cpu.intr_trigger_on_off({1'b0,16'hFFFF},1'b0);
            end
         join_none
         top.cpu.read_data(8'h0B, data_out, err);     //đọc data ra coi thử nó có bằng 0?
         if (data_out == 8'hFF) begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --PASS--", $time, data_in, data_out);
            fail = 1'b0;
         end
         else begin
            $display("At %0t, wdata = 8'h%0h, rdata = 8'h%0h --FAIL--", $time, data_in, data_out);
            fail = 1'b1;
         end
         count++;
      end
      #100;
      top.get_result(fail);
      $finish;
   end
endmodule