module prio_deter(input pclk,
                  input preset_n,
                  input IRQ0_req, IRQ1_req, IRQ2_req, IRQ3_req, IRQ4_req, IRQ5_req, IRQ6_req, IRQ7_req,
                  input [7:0] prio_config_A, prio_config_B, prio_config_C, prio_config_D,    //mức priority của tín hiệu ngắt
                  output intr_ev,
                  input I_flag
                  );

   logic [2:0] prio_inter01, prio_inter23, prio_inter45, prio_inter67;
   logic [2:0] prio_inter0123, prio_inter4567;
   logic irq01, irq23, irq45, irq67;
   logic irq0123, irq4567;
   logic irq_final;
   
   logic [7:0] prev_IRQ_stg1;
   logic [3:0] prev_IRQ_stg2;
   logic [1:0] prev_IRQ_stg3;

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) begin
         prev_IRQ_stg1 <= 8'h0;
         prev_IRQ_stg2 <= 4'h0;
         prev_IRQ_stg3 <= 2'b0;
      end
      else begin
         prev_IRQ_stg1 <= {IRQ7_req, IRQ6_req, IRQ5_req, IRQ4_req, IRQ3_req, IRQ2_req, IRQ1_req, IRQ0_req};
         prev_IRQ_stg2 <= {irq67, irq45, irq23, irq01};
         prev_IRQ_stg3 <= {irq4567, irq0123};
      end
   end

   function logic check(input logic [2:0] prio1, prio2, input logic prev1, curr1, prev2, curr2);      //hiện tại giống với cái trước
      return (((prev1^~curr1)&&(prio1>=prio2)&&(prev2^~curr2))||(!prev1&&curr1));             //hoặc cái trước =0 còn cái sau bằng 1
   endfunction

   //setup giá trị ban đầu là IRQ0 --> ipra0[2:0], IRQ1 --> ipra0[6:4],...
   // --------------EXTERNAL INTERRUPT---------------------

   //IRQ0 vs IRQ1
   always_comb begin
      if (check(prio_config_A[6:4],prio_config_A[2:0],prev_IRQ_stg1[1],IRQ1_req,prev_IRQ_stg1[0],IRQ0_req)) begin      //IRQ1 >= IRQ0
         irq01 = IRQ1_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter01 = prio_config_A[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq01 = IRQ0_req;
         prio_inter01 = prio_config_A[2:0];
      end
   end

   //IRQ2 vs IRQ3
   always_comb begin
      if (check(prio_config_B[6:4],prio_config_B[2:0],prev_IRQ_stg1[3],IRQ3_req,prev_IRQ_stg1[2],IRQ2_req)) begin      //IRQ1 >= IRQ0
         irq23 = IRQ3_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter23 = prio_config_B[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq23 = IRQ2_req;
         prio_inter23 = prio_config_B[2:0];
      end
   end

   //IRQ01 vs IRQ23
   always_comb begin
      if (check(prio_inter01,prio_inter23,prev_IRQ_stg2[0],irq01,prev_IRQ_stg2[1],irq23)) begin
         irq0123 = irq01;
         prio_inter0123 = prio_inter01;
      end
      else begin
         irq0123 = irq23;
         prio_inter0123 = prio_inter23;
      end
   end

   //IRQ4 vs IRQ5
   always_comb begin
      if (check(prio_config_C[6:4],prio_config_C[2:0],prev_IRQ_stg1[5],IRQ5_req,prev_IRQ_stg1[4],IRQ4_req)) begin      //IRQ1 >= IRQ0
         irq45 = IRQ5_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter45 = prio_config_C[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq45 = IRQ4_req;
         prio_inter45 = prio_config_C[2:0];
      end
   end

   //IRQ6 vs IRQ7
   always_comb begin
      if (check(prio_config_D[6:4],prio_config_D[2:0],prev_IRQ_stg1[7],IRQ7_req,prev_IRQ_stg1[6],IRQ6_req)) begin      //IRQ1 >= IRQ0
         irq67 = IRQ7_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter67 = prio_config_D[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq67 = IRQ6_req;
         prio_inter67 = prio_config_D[2:0];
      end
   end

   //IRQ45 vs IRQ67
   always_comb begin
      if (check(prio_inter45,prio_inter67,prev_IRQ_stg2[2],irq45,prev_IRQ_stg2[3],irq67)) begin
         irq4567 = irq45;
         prio_inter4567 = prio_inter45;
      end
      else begin
         irq4567 = irq67;
         prio_inter4567 = prio_inter67;
      end
   end
   //EXTERNAL INTERRUPT FINAL
   always_comb begin
      if (check(prio_inter0123,prio_inter4567,prev_IRQ_stg3[0],irq0123,prev_IRQ_stg3[1],irq4567)) irq_final = irq0123;
      else irq_final = irq4567;
   end

   //nếu có tín hiệu ngắt nào thì đưa ra địa chỉ nó luôn(trong 1 lúc chỉ có 1 ngắt)


   assign intr_ev = irq_final; //báo có ngắt cho CPU
endmodule