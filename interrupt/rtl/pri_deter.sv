module prio_deter(input NMI_req,
                  input IRQ0_req, IRQ1_req, IRQ2_req, IRQ3_req, IRQ4_req, IRQ5_req, IRQ6_req, IRQ7_req,
                  input Int_IRQ0_req, Int_IRQ1_req, Int_IRQ2_req, Int_IRQ3_req, Int_IRQ4_req, Int_IRQ5_req, Int_IRQ6_req, Int_IRQ7_req,
                  input i_bit,
                  input [7:0] prio_config_A, prio_config_B, prio_config_C, prio_config_D,    //mức priority của tín hiệu ngắt
                  output [4:0] vt_no,
                  output intr_ev
                  );

   logic [2:0] prio_inter01, prio_inter23, prio_inter45, prio_inter67;
   logic [2:0] prio_inter0123, prio_inter4567;
   logic irq01, irq23, irq45, irq67;
   logic irq0123, irq4567;
   logic irq_final;

   logic [2:0] Int_prio_inter01, Int_prio_inter23, Int_prio_inter45, Int_prio_inter67;
   logic [2:0] Int_prio_inter0123, Int_prio_inter4567;
   logic Int_irq01, Int_irq23, Int_irq45, Int_irq67;
   logic Int_irq0123, Int_irq4567;
   logic Int_irq_final;
   logic [4:0] vt_no_irq, vt_no_Int_irq;

   //setup giá trị ban đầu là IRQ0 --> ipra0[2:0], IRQ1 --> ipra0[6:4],...
   // --------------EXTERNAL INTERRUPT---------------------

   //IRQ0 vs IRQ1
   always @(*) begin
      if (prio_config_A[6:4] >= prio_config_A[2:0]) begin      //IRQ1 >= IRQ0
         irq01 = IRQ1_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter01 = prio_config_A[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq01 = IRQ0_req;
         prio_inter01 = prio_config_A[2:0];
      end
   end

   //IRQ2 vs IRQ3
   always @(*) begin
      if (prio_config_B[6:4] >= prio_config_B[2:0]) begin      //IRQ1 >= IRQ0
         irq23 = IRQ3_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter23 = prio_config_B[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq23 = IRQ2_req;
         prio_inter23 = prio_config_B[2:0];
      end
   end

   //IRQ01 vs IRQ23
   always @(*) begin
      if (prio_inter01 >= prio_inter23) begin
         irq0123 = irq01;
         prio_inter0123 = prio_inter01;
      end
      else begin
         irq0123 = irq23;
         prio_inter0123 = prio_inter23;
      end
   end

   //IRQ4 vs IRQ5
   always @(*) begin
      if (prio_config_C[6:4] >= prio_config_C[2:0]) begin      //IRQ1 >= IRQ0
         irq45 = IRQ5_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter45 = prio_config_C[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq45 = IRQ4_req;
         prio_inter45 = prio_config_C[2:0];
      end
   end

   //IRQ6 vs IRQ7
   always @(*) begin
      if (prio_config_D[6:4] >= prio_config_D[2:0]) begin      //IRQ1 >= IRQ0
         irq67 = IRQ7_req;                         //tín hiệu ngắt 1 thông qua
         prio_inter67 = prio_config_D[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         irq67 = IRQ6_req;
         prio_inter67 = prio_config_D[2:0];
      end
   end

   //IRQ45 vs IRQ67
   always @(*) begin
      if (prio_inter45 >= prio_inter67) begin
         irq4567 = irq45;
         prio_inter4567 = prio_inter45;
      end
      else begin
         irq4567 = irq67;
         prio_inter4567 = prio_inter67;
      end
   end
   //EXTERNAL INTERRUPT FINAL
   always @(*) begin
      if (prio_inter0123 >= prio_inter4567) irq_final = irq0123;
      else irq_final = irq4567;
   end

   // ------------------------INTERNAL IRQ--------------------------
   
    //IRQ0 vs IRQ1
   always @(*) begin
      if (prio_config_A[6:4] >= prio_config_A[2:0]) begin      //IRQ1 >= IRQ0
         Int_irq01 = Int_IRQ1_req;                         //tín hiệu ngắt 1 thông qua
         Int_prio_inter01 = prio_config_A[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         Int_irq01 = Int_IRQ0_req;
         Int_prio_inter01 = prio_config_A[2:0];
      end
   end

   //IRQ2 vs IRQ3
   always @(*) begin
      if (prio_config_B[6:4] >= prio_config_B[2:0]) begin      //IRQ1 >= IRQ0
         Int_irq23 = Int_IRQ3_req;                         //tín hiệu ngắt 1 thông qua
         Int_prio_inter23 = prio_config_B[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         Int_irq23 = Int_IRQ2_req;
         Int_prio_inter23 = prio_config_B[2:0];
      end
   end

   //IRQ01 vs IRQ23
   always @(*) begin
      if (Int_prio_inter01 >= Int_prio_inter23) begin
         Int_irq0123 = Int_irq01;
         Int_prio_inter0123 = Int_prio_inter01;
      end
      else begin
         Int_irq0123 = Int_irq23;
         Int_prio_inter0123 = Int_prio_inter23;
      end
   end

   //IRQ4 vs IRQ5
   always @(*) begin
      if (prio_config_C[6:4] >= prio_config_C[2:0]) begin      //IRQ1 >= IRQ0
         Int_irq45 = Int_IRQ5_req;                         //tín hiệu ngắt 1 thông qua
         Int_prio_inter45 = prio_config_C[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         Int_irq45 = Int_IRQ4_req;
         Int_prio_inter45 = prio_config_C[2:0];
      end
   end

   //IRQ6 vs IRQ7
   always @(*) begin
      if (prio_config_D[6:4] >= prio_config_D[2:0]) begin      //IRQ1 >= IRQ0
         Int_irq67 = Int_IRQ7_req;                         //tín hiệu ngắt 1 thông qua
         Int_prio_inter67 = prio_config_D[6:4];     //pick lấy mức ưu tiên 1 của IRQ1
      end
      else begin
         Int_irq67 = Int_IRQ6_req;
         Int_prio_inter67 = prio_config_D[2:0];
      end
   end

   //IRQ45 vs IRQ67
   always @(*) begin
      if (Int_prio_inter45 >= Int_prio_inter67) begin
         Int_irq4567 = Int_irq45;
         Int_prio_inter4567 = Int_prio_inter45;
      end
      else begin
         Int_irq4567 = Int_irq67;
         Int_prio_inter4567 = Int_prio_inter67;
      end
   end

   always @(*) begin
      if (Int_prio_inter0123 >= Int_prio_inter4567) Int_irq_final = Int_irq0123;
      else Int_irq_final = Int_irq4567;
   end

   //nếu có tín hiệu ngắt nào thì đưa ra địa chỉ nó luôn(trong 1 lúc chỉ có 1 ngắt)
   assign vt_no_irq = IRQ0_req ? 5'd2: IRQ1_req ? 5'd3:
                      IRQ2_req ? 5'd4: IRQ3_req ? 5'd5:
                      IRQ4_req ? 5'd6: IRQ5_req ? 5'd7:
                     IRQ6_req ? 5'd8: IRQ7_req ? 5'd9:5'd0;

   //nếu có nhiều hơn 1 ngắt(tức là 1 ngắt đang thực hiện, ngắt khác chen vào thì coi priority)
   assign vt_no_Int_irq = Int_IRQ0_req ? 5'd10: Int_IRQ1_req ? 5'd11:
                                   Int_IRQ2_req ? 5'd12: Int_IRQ3_req ? 5'd13:
                                   Int_IRQ4_req ? 5'd14: Int_IRQ5_req ? 5'd15:
                                   Int_IRQ6_req ? 5'd16: Int_IRQ7_req ? 5'd17:5'd0;

   assign irq_sel = IRQ0_req | IRQ1_req | IRQ2_req | IRQ3_req | IRQ4_req | IRQ5_req | IRQ6_req | IRQ7_req;
   //có ngắt hay 0?
   assign vt_no = NMI_req ? 5'd1: //NMI hit -> output vector of NMI
                       irq_sel ? {4'b1111,~i_bit} & vt_no_irq: {4'b1111,~i_bit} & vt_no_Int_irq; //else if irq hit -> select irq else select internal irq

   assign intr_ev = NMI_req | irq_final | Int_irq_final; //báo có ngắt cho CPU
endmodule