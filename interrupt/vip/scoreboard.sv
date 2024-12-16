module scoreboard(input pclk,
                  input preset_n,
                  input pready,
                  input psel,
                  input penable,
                  input pwrite,
                  input [7:0] pwdata,
                  input [7:0] prdata,
                  input [7:0] paddr,
                  input pslverr,
                  output logic err);

   event ev1, ev2, ev3;

   logic [7:0] expected_data[15];
   logic [7:0] mask_data[15];

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) begin
         for (int i=0; i<15;i++) begin
            if (i === 13) expected_data[i] <= 8'hff;     //thanh ghi timerout
            else expected_data[i] <= 8'h00;
         end
      end
      else if (psel&&pwrite&&penable&&pready) begin
         if (paddr == 11) expected_data[paddr] <= expected_data[paddr] | testbench.int_ctrl.IRQ_state;   //thanh ghi ISRA
         else if (paddr == 12) expected_data[paddr] <= expected_data[paddr] | testbench.int_ctrl.Int_IRQ_state;   //thanh ghi ISRB
         else if (paddr == 13) expected_data[paddr] <= expected_data[0][2]? (pwdata&mask_data[paddr]) : expected_data[paddr];
         else expected_data[paddr] <= pwdata&mask_data[paddr];
      end
      else expected_data[paddr] <= expected_data[paddr];
   end

   always @(*) begin
      if (psel&&!pwrite&&penable&&pready) begin
         if (paddr >= 8'h00 && paddr < 8'h0F) begin
            @(posedge pclk);
            #1;
            err = err | ~(prdata === expected_data[paddr]);
            $display("[SCOREBOARD monitor] at t = %t error =%b read data=0x%0h expect=0x%0h addr=0x%0h",$time,err,prdata,expected_data[paddr],paddr);
            $display("mask data is 0x%0h",mask_data[paddr]);
            $display("\n");
         end else begin
            err = err;
            $display("accessing to unsupported paddr 0x%0h, pslverr should be asserted",paddr);
         end
      end
   end

initial begin
   err = 0;
   mask_data[0]  = 8'h77;
   mask_data[1]  = 8'h77;
   mask_data[2]  = 8'hFF;
   mask_data[3]  = 8'hFF;
   mask_data[4]  = 8'hFF;
   mask_data[5]  = 8'hFF;
   mask_data[6]  = 8'hFF;
   mask_data[7]  = 8'hFF;
   mask_data[8]  = 8'hFF;
   mask_data[9]  = 8'hFF;
   mask_data[10] = 8'hFF;
   mask_data[11] = 8'hFF;
   mask_data[12] = 8'h03;
   mask_data[13] = 8'h77;
   mask_data[14] = 8'h77;
end

endmodule