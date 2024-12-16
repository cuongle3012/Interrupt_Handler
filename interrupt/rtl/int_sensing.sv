module int_sensing(input pclk,
                  input preset_n,
                  input NMI,
                  input IRQ0, IRQ1, IRQ2, IRQ3, IRQ4, IRQ5, IRQ6, IRQ7,
                  input Int_IRQ0, Int_IRQ1, Int_IRQ2, Int_IRQ3, Int_IRQ4, Int_IRQ5, Int_IRQ6, Int_IRQ7,
                  input [1:0] NMI_eg,
                  input [7:0] IRQ_enable, Int_IRQ_enable,
                  input [15:0] IRQ_sense, Int_IRQ_sense,
                  output NMI_req,
                  output IRQ0_req, IRQ1_req, IRQ2_req, IRQ3_req, IRQ4_req, IRQ5_req, IRQ6_req, IRQ7_req,
                  output Int_IRQ0_req, Int_IRQ1_req, Int_IRQ2_req, Int_IRQ3_req, Int_IRQ4_req, Int_IRQ5_req, Int_IRQ6_req, Int_IRQ7_req
                  );

   logic NMI_hit;
   logic IRQ0_hit;
   logic IRQ1_hit;
   logic IRQ2_hit;
   logic IRQ3_hit;
   logic IRQ4_hit;
   logic IRQ5_hit;
   logic IRQ6_hit;
   logic IRQ7_hit;
   logic Int_IRQ0_hit;
   logic Int_IRQ1_hit;
   logic Int_IRQ2_hit;
   logic Int_IRQ3_hit;
   logic Int_IRQ4_hit;
   logic Int_IRQ5_hit;
   logic Int_IRQ6_hit;
   logic Int_IRQ7_hit;

   logic irq0_fall;
   logic irq0_rise;
   logic irq1_fall;
   logic irq1_rise;
   logic irq2_fall;
   logic irq2_rise;
   logic irq3_fall;
   logic irq3_rise;
   logic irq4_fall;
   logic irq4_rise;
   logic irq5_fall;
   logic irq5_rise;
   logic irq6_fall;
   logic irq6_rise;
   logic irq7_fall;
   logic irq7_rise;

   logic irq0_both;
   logic irq0_is_0;
   logic irq1_both;
   logic irq1_is_0;
   logic irq2_both;
   logic irq2_is_0;
   logic irq3_both;
   logic irq3_is_0;
   logic irq4_both;
   logic irq4_is_0;
   logic irq5_both;
   logic irq5_is_0;
   logic irq6_both;
   logic irq6_is_0;
   logic irq7_both;
   logic irq7_is_0;

   logic Int_irq0_fall;
   logic Int_irq0_rise;
   logic Int_irq1_fall;
   logic Int_irq1_rise;
   logic Int_irq2_fall;
   logic Int_irq2_rise;
   logic Int_irq3_fall;
   logic Int_irq3_rise;
   logic Int_irq4_fall;
   logic Int_irq4_rise;
   logic Int_irq5_fall;
   logic Int_irq5_rise;
   logic Int_irq6_fall;
   logic Int_irq6_rise;
   logic Int_irq7_fall;
   logic Int_irq7_rise;

   logic Int_irq0_both;
   logic Int_irq0_is_0;
   logic Int_irq1_both;
   logic Int_irq1_is_0;
   logic Int_irq2_both;
   logic Int_irq2_is_0;
   logic Int_irq3_both;
   logic Int_irq3_is_0;
   logic Int_irq4_both;
   logic Int_irq4_is_0;
   logic Int_irq5_both;
   logic Int_irq5_is_0;
   logic Int_irq6_both;
   logic Int_irq6_is_0;
   logic Int_irq7_both;
   logic Int_irq7_is_0;

   logic NMI_rise;
   logic NMI_fall;
   logic NMI_both;
   logic NMI_is_0;

   edge_detection IRQ0_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ0),
                           .rs_det(irq0_rise),
                           .fl_det(irq0_fall),
                           .ed_det(irq0_both),
                           .lv_det(irq0_is_0));

   edge_detection IRQ1_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ1),
                           .rs_det(irq1_rise),
                           .fl_det(irq1_fall),
                           .ed_det(irq1_both),
                           .lv_det(irq1_is_0));

edge_detection IRQ2_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ2),
                           .rs_det(irq2_rise),
                           .fl_det(irq2_fall),
                           .ed_det(irq2_both),
                           .lv_det(irq2_is_0));

edge_detection IRQ3_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ3),
                           .rs_det(irq3_rise),
                           .fl_det(irq3_fall),
                           .ed_det(irq3_both),
                           .lv_det(irq3_is_0));

edge_detection IRQ4_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ4),
                           .rs_det(irq4_rise),
                           .fl_det(irq4_fall),
                           .ed_det(irq4_both),
                           .lv_det(irq4_is_0));

edge_detection IRQ5_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ5),
                           .rs_det(irq5_rise),
                           .fl_det(irq5_fall),
                           .ed_det(irq5_both),
                           .lv_det(irq5_is_0));

edge_detection IRQ6_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ6),
                           .rs_det(irq6_rise),
                           .fl_det(irq6_fall),
                           .ed_det(irq6_both),
                           .lv_det(irq6_is_0));

edge_detection IRQ7_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(IRQ7),
                           .rs_det(irq7_rise),
                           .fl_det(irq7_fall),
                           .ed_det(irq7_both),
                           .lv_det(irq7_is_0));

edge_detection Int_IRQ0_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ0),
                           .rs_det(Int_irq0_rise),
                           .fl_det(Int_irq0_fall),
                           .ed_det(Int_irq0_both),
                           .lv_det(Int_irq0_is_0));

   edge_detection Int_IRQ1_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ1),
                           .rs_det(Int_irq1_rise),
                           .fl_det(Int_irq1_fall),
                           .ed_det(Int_irq1_both),
                           .lv_det(Int_irq1_is_0));

edge_detection Int_IRQ2_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ2),
                           .rs_det(Int_irq2_rise),
                           .fl_det(Int_irq2_fall),
                           .ed_det(Int_irq2_both),
                           .lv_det(Int_irq2_is_0));

edge_detection Int_IRQ3_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ3),
                           .rs_det(Int_irq3_rise),
                           .fl_det(Int_irq3_fall),
                           .ed_det(Int_irq3_both),
                           .lv_det(Int_irq3_is_0));

edge_detection Int_IRQ4_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ4),
                           .rs_det(Int_irq4_rise),
                           .fl_det(Int_irq4_fall),
                           .ed_det(Int_irq4_both),
                           .lv_det(Int_irq4_is_0));

edge_detection Int_IRQ5_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ5),
                           .rs_det(Int_irq5_rise),
                           .fl_det(Int_irq5_fall),
                           .ed_det(Int_irq5_both),
                           .lv_det(Int_irq5_is_0));

edge_detection Int_IRQ6_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ6),
                           .rs_det(Int_irq6_rise),
                           .fl_det(Int_irq6_fall),
                           .ed_det(Int_irq6_both),
                           .lv_det(Int_irq6_is_0));

edge_detection Int_IRQ7_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(Int_IRQ7),
                           .rs_det(Int_irq7_rise),
                           .fl_det(Int_irq7_fall),
                           .ed_det(Int_irq7_both),
                           .lv_det(Int_irq7_is_0));

   edge_detection NMI_detector(.pclk(pclk),
                           .preset_n(preset_n),
                           .data_d(NMI),
                           .rs_det(NMI_rise),
                           .fl_det(NMI_fall),
                           .ed_det(NMI_both),
                           .lv_det(NMI_is_0));

   //NMI has been hit?
   always @(*) begin
      case (IRQ_sense[1:0])
         2'b00: IRQ0_hit = irq0_is_0;
         2'b01: IRQ0_hit = irq0_fall;
         2'b10: IRQ0_hit = irq0_rise;
         2'b11: IRQ0_hit = irq0_both;
         default: IRQ0_hit = 1'b0;
      endcase
   end  

//External Interrupt has been hit?
   always @(*) begin
      case (NMI_eg[1:0])
         2'b00: NMI_hit = NMI_is_0;
         2'b01: NMI_hit = NMI_fall;
         2'b10: NMI_hit = NMI_rise;
         2'b11: NMI_hit = NMI_both;
         default: NMI_hit = 1'b0;
      endcase
   end  

   always @(*) begin
      case (IRQ_sense[3:2])
         2'b00: IRQ1_hit = irq1_is_0;
         2'b01: IRQ1_hit = irq1_fall;
         2'b10: IRQ1_hit = irq1_rise;
         2'b11: IRQ1_hit = irq1_both;
         default: IRQ1_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (IRQ_sense[5:4])
         2'b00: IRQ2_hit = irq2_is_0;
         2'b01: IRQ2_hit = irq2_fall;
         2'b10: IRQ2_hit = irq2_rise;
         2'b11: IRQ2_hit = irq2_both;
         default: IRQ2_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (IRQ_sense[7:6])
         2'b00: IRQ3_hit = irq3_is_0;
         2'b01: IRQ3_hit = irq3_fall;
         2'b10: IRQ3_hit = irq3_rise;
         2'b11: IRQ3_hit = irq3_both;
         default: IRQ3_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (IRQ_sense[9:8])
         2'b00: IRQ4_hit = irq4_is_0;
         2'b01: IRQ4_hit = irq4_fall;
         2'b10: IRQ4_hit = irq4_rise;
         2'b11: IRQ4_hit = irq4_both;
         default: IRQ4_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (IRQ_sense[11:10])
         2'b00: IRQ5_hit = irq5_is_0;
         2'b01: IRQ5_hit = irq5_fall;
         2'b10: IRQ5_hit = irq5_rise;
         2'b11: IRQ5_hit = irq5_both;
         default: IRQ5_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (IRQ_sense[13:12])
         2'b00: IRQ6_hit = irq6_is_0;
         2'b01: IRQ6_hit = irq6_fall;
         2'b10: IRQ6_hit = irq6_rise;
         2'b11: IRQ6_hit = irq6_both;
         default: IRQ6_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (IRQ_sense[15:14])
         2'b00: IRQ7_hit = irq7_is_0;
         2'b01: IRQ7_hit = irq7_fall;
         2'b10: IRQ7_hit = irq7_rise;
         2'b11: IRQ7_hit = irq7_both;
         default: IRQ7_hit = 1'b0;
      endcase
   end

   //Internal Interrupt has been hit?

   always @(*) begin
      case (Int_IRQ_sense[1:0])
         2'b00: Int_IRQ0_hit = Int_irq0_is_0;
         2'b01: Int_IRQ0_hit = Int_irq0_fall;
         2'b10: Int_IRQ0_hit = Int_irq0_rise;
         2'b11: Int_IRQ0_hit = Int_irq0_both;
         default: Int_IRQ0_hit = 1'b0;
      endcase
   end  

   always @(*) begin
      case (Int_IRQ_sense[3:2])
         2'b00: Int_IRQ1_hit = Int_irq1_is_0;
         2'b01: Int_IRQ1_hit = Int_irq1_fall;
         2'b10: Int_IRQ1_hit = Int_irq1_rise;
         2'b11: Int_IRQ1_hit = Int_irq1_both;
         default: Int_IRQ1_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (Int_IRQ_sense[5:4])
         2'b00: Int_IRQ2_hit = Int_irq2_is_0;
         2'b01: Int_IRQ2_hit = Int_irq2_fall;
         2'b10: Int_IRQ2_hit = Int_irq2_rise;
         2'b11: Int_IRQ2_hit = Int_irq2_both;
         default: Int_IRQ2_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (Int_IRQ_sense[7:6])
         2'b00: Int_IRQ3_hit = Int_irq3_is_0;
         2'b01: Int_IRQ3_hit = Int_irq3_fall;
         2'b10: Int_IRQ3_hit = Int_irq3_rise;
         2'b11: Int_IRQ3_hit = Int_irq3_both;
         default: Int_IRQ3_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (Int_IRQ_sense[9:8])
         2'b00: Int_IRQ4_hit = Int_irq4_is_0;
         2'b01: Int_IRQ4_hit = Int_irq4_fall;
         2'b10: Int_IRQ4_hit = Int_irq4_rise;
         2'b11: Int_IRQ4_hit = Int_irq4_both;
         default: Int_IRQ4_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (Int_IRQ_sense[11:10])
         2'b00: Int_IRQ5_hit = Int_irq5_is_0;
         2'b01: Int_IRQ5_hit = Int_irq5_fall;
         2'b10: Int_IRQ5_hit = Int_irq5_rise;
         2'b11: Int_IRQ5_hit = Int_irq5_both;
         default: Int_IRQ5_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (Int_IRQ_sense[13:12])
         2'b00: Int_IRQ6_hit = Int_irq6_is_0;
         2'b01: Int_IRQ6_hit = Int_irq6_fall;
         2'b10: Int_IRQ6_hit = Int_irq6_rise;
         2'b11: Int_IRQ6_hit = Int_irq6_both;
         default: Int_IRQ6_hit = 1'b0;
      endcase
   end 

   always @(*) begin
      case (Int_IRQ_sense[15:14])
         2'b00: Int_IRQ7_hit = Int_irq7_is_0;
         2'b01: Int_IRQ7_hit = Int_irq7_fall;
         2'b10: Int_IRQ7_hit = Int_irq7_rise;
         2'b11: Int_IRQ7_hit = Int_irq7_both;
         default: Int_IRQ7_hit = 1'b0;
      endcase
   end                    

   logic NMI_hit_r;
   logic IRQ0_hit_r;
   logic IRQ1_hit_r;
   logic IRQ2_hit_r;
   logic IRQ3_hit_r;
   logic IRQ4_hit_r;
   logic IRQ5_hit_r;
   logic IRQ6_hit_r;
   logic IRQ7_hit_r;
            
   logic Int_IRQ0_hit_r;
   logic Int_IRQ1_hit_r;
   logic Int_IRQ2_hit_r;
   logic Int_IRQ3_hit_r;
   logic Int_IRQ4_hit_r;
   logic Int_IRQ5_hit_r;
   logic Int_IRQ6_hit_r;
   logic Int_IRQ7_hit_r;

   always@(posedge pclk, negedge preset_n) begin
    if(!preset_n) begin
       NMI_hit_r     <= 1'b0;
      IRQ0_hit_r     <= 1'b0;
      IRQ1_hit_r     <= 1'b0;
      IRQ2_hit_r     <= 1'b0;
      IRQ3_hit_r     <= 1'b0;
      IRQ4_hit_r     <= 1'b0;
      IRQ5_hit_r     <= 1'b0;
      IRQ6_hit_r     <= 1'b0;
      IRQ7_hit_r     <= 1'b0;
      Int_IRQ0_hit_r <= 1'b0;
      Int_IRQ1_hit_r <= 1'b0;
      Int_IRQ2_hit_r <= 1'b0;
      Int_IRQ3_hit_r <= 1'b0;
      Int_IRQ4_hit_r <= 1'b0;
      Int_IRQ5_hit_r <= 1'b0;
      Int_IRQ6_hit_r <= 1'b0;
      Int_IRQ7_hit_r <= 1'b0;
    end else begin
       NMI_hit_r     <=  NMI_hit;
      IRQ0_hit_r     <= IRQ0_hit;
      IRQ1_hit_r     <= IRQ1_hit;
      IRQ2_hit_r     <= IRQ2_hit;
      IRQ3_hit_r     <= IRQ3_hit;
      IRQ4_hit_r     <= IRQ4_hit;
      IRQ5_hit_r     <= IRQ5_hit;
      IRQ6_hit_r     <= IRQ6_hit;
      IRQ7_hit_r     <= IRQ7_hit;
      Int_IRQ0_hit_r <= Int_IRQ0_hit;
      Int_IRQ1_hit_r <= Int_IRQ1_hit;
      Int_IRQ2_hit_r <= Int_IRQ2_hit;
      Int_IRQ3_hit_r <= Int_IRQ3_hit;
      Int_IRQ4_hit_r <= Int_IRQ4_hit;
      Int_IRQ5_hit_r <= Int_IRQ5_hit;
      Int_IRQ6_hit_r <= Int_IRQ6_hit;
      Int_IRQ7_hit_r <= Int_IRQ7_hit;
    end
end

   //trừ NMI ra, thì phải được kích hoạt cho phép ngắt thì mới tạo ra tín hiệu ngắt thật sự
  assign    NMI_req  = NMI_hit_r;
  assign    IRQ0_req = IRQ0_hit_r & IRQ_enable[0];
  assign    IRQ1_req = IRQ1_hit_r & IRQ_enable[1];
  assign    IRQ2_req = IRQ2_hit_r & IRQ_enable[2];
  assign    IRQ3_req = IRQ3_hit_r & IRQ_enable[3];
  assign    IRQ4_req = IRQ4_hit_r & IRQ_enable[4];
  assign    IRQ5_req = IRQ5_hit_r & IRQ_enable[5];
  assign    IRQ6_req = IRQ6_hit_r & IRQ_enable[6];
  assign    IRQ7_req = IRQ7_hit_r & IRQ_enable[7];

  assign Int_IRQ0_req = Int_IRQ0_hit_r & Int_IRQ_enable[0];
  assign Int_IRQ1_req = Int_IRQ1_hit_r & Int_IRQ_enable[1];
  assign Int_IRQ2_req = Int_IRQ2_hit_r & Int_IRQ_enable[2];
  assign Int_IRQ3_req = Int_IRQ3_hit_r & Int_IRQ_enable[3];
  assign Int_IRQ4_req = Int_IRQ4_hit_r & Int_IRQ_enable[4];
  assign Int_IRQ5_req = Int_IRQ5_hit_r & Int_IRQ_enable[5];
  assign Int_IRQ6_req = Int_IRQ6_hit_r & Int_IRQ_enable[6];
  assign Int_IRQ7_req = Int_IRQ7_hit_r & Int_IRQ_enable[7];

endmodule