module interrupt_controller(input pclk,
                           input preset_n,
                           input pwrite,
                           input psel,
                           input penable,
                           output pready,
                           input [7:0] paddr,
                           input [7:0] pwdata,
                           output logic [7:0] prdata,
                           input NMI,
                           input [7:0] IRQ,
                           input [7:0] Int_IRQ,
                           input i_bit,
                           output pslverr,
                           output intr_ev,
                           output [4:0] vt_no,
                           input I_flag,
                           input UI_flag
);

   logic [7:0] ipra;
   logic [7:0] iprb;
   logic [7:0] iprc;
   logic [7:0] iprd;
   logic [7:0] iscra;
   logic [7:0] iscrb;
   logic [7:0] iscrc;
   logic [7:0] iscrd;
   logic [7:0] iera;
   logic [7:0] ierb;
   logic [7:0] isra;
   logic [7:0] isrb;
   logic [7:0] tmo;
   logic [7:0] ssr;
   logic [7:0] syscr;
   logic [7:0] IRQ_state;
   logic [7:0] Int_IRQ_state;

   logic NMI_req;
   logic IRQ0_req;
   logic IRQ1_req;
   logic IRQ2_req;
   logic IRQ3_req;
   logic IRQ4_req;
   logic IRQ5_req;
   logic IRQ6_req;
   logic IRQ7_req;
   logic Int_IRQ0_req;
   logic Int_IRQ1_req;
   logic Int_IRQ2_req;
   logic Int_IRQ3_req;
   logic Int_IRQ4_req;
   logic Int_IRQ5_req;
   logic Int_IRQ6_req;
   logic Int_IRQ7_req;

   //ghép lại 1 cụm để nhét vào APB ghi data vào phần R/w*
   assign IRQ_state = {IRQ7_req, IRQ6_req, IRQ5_req, IRQ4_req, IRQ3_req, IRQ2_req, IRQ1_req, IRQ0_req};
   assign Int_IRQ_state = {Int_IRQ7_req, Int_IRQ6_req, Int_IRQ5_req, Int_IRQ4_req, Int_IRQ3_req, Int_IRQ2_req, Int_IRQ1_req, Int_IRQ0_req};

   apb_rw apb_protocol(
      .pclk(pclk),
      .preset_n(preset_n),
      .psel(psel),
      .paddr(paddr),
      .penable(penable),
      .pwrite(pwrite),
      .pwdata(pwdata),
      .prdata(prdata),
      .pready(pready),
      .pslverr(pslverr),
      .syscr(syscr),
      .ipra(ipra),
      .iprb(iprb),
      .iprc(iprc),
      .iprd(iprd),
      .iscra(iscra),
      .iscrb(iscrb),
      .iscrc(iscrc),
      .iscrd(iscrd),
      .iera(iera),
      .ierb(ierb),
      .isra(isra),
      .isrb(isrb),
      .tmo(tmo),
      .ssr(ssr),
      .IRQ_state(IRQ_state),
      .Int_IRQ_state(Int_IRQ_state)
   );

   int_sensing int_sense(
      .pclk(pclk),
      .preset_n(preset_n),
      .NMI(NMI),
      .IRQ0(IRQ[0]),
      .IRQ1(IRQ[1]),
      .IRQ2(IRQ[2]),
      .IRQ3(IRQ[3]),
      .IRQ4(IRQ[4]),
      .IRQ5(IRQ[5]),
      .IRQ6(IRQ[6]),
      .IRQ7(IRQ[7]),
      .Int_IRQ0(Int_IRQ[0]),
      .Int_IRQ1(Int_IRQ[1]),
      .Int_IRQ2(Int_IRQ[2]),
      .Int_IRQ3(Int_IRQ[3]),
      .Int_IRQ4(Int_IRQ[4]),
      .Int_IRQ5(Int_IRQ[5]),
      .Int_IRQ6(Int_IRQ[6]),
      .Int_IRQ7(Int_IRQ[7]),
      .NMI_eg(syscr[1:0]),
      .IRQ_enable(iera),
      .Int_IRQ_enable(ierb),
      .IRQ_sense({iscrb, iscra}),
      .Int_IRQ_sense({iscrd, iscrc}),
      .NMI_req(NMI_req),
      .IRQ0_req(IRQ0_req),
      .IRQ1_req(IRQ1_req),
      .IRQ2_req(IRQ2_req),
      .IRQ3_req(IRQ3_req),
      .IRQ4_req(IRQ4_req),
      .IRQ5_req(IRQ5_req),
      .IRQ6_req(IRQ6_req),
      .IRQ7_req(IRQ7_req),
      .Int_IRQ0_req(Int_IRQ0_req),
      .Int_IRQ1_req(Int_IRQ1_req),
      .Int_IRQ2_req(Int_IRQ2_req),
      .Int_IRQ3_req(Int_IRQ3_req),
      .Int_IRQ4_req(Int_IRQ4_req),
      .Int_IRQ5_req(Int_IRQ5_req),
      .Int_IRQ6_req(Int_IRQ6_req),
      .Int_IRQ7_req(Int_IRQ7_req)
   );

   prio_deter prio_deter(.NMI_req(NMI_req),
               .IRQ0_req(IRQ0_req),
      .IRQ1_req(IRQ1_req),
      .IRQ2_req(IRQ2_req),
      .IRQ3_req(IRQ3_req),
      .IRQ4_req(IRQ4_req),
      .IRQ5_req(IRQ5_req),
      .IRQ6_req(IRQ6_req),
      .IRQ7_req(IRQ7_req),
      .Int_IRQ0_req(Int_IRQ0_req),
      .Int_IRQ1_req(Int_IRQ1_req),
      .Int_IRQ2_req(Int_IRQ2_req),
      .Int_IRQ3_req(Int_IRQ3_req),
      .Int_IRQ4_req(Int_IRQ4_req),
      .Int_IRQ5_req(Int_IRQ5_req),
      .Int_IRQ6_req(Int_IRQ6_req),
      .Int_IRQ7_req(Int_IRQ7_req),
      .i_bit(i_bit),
      .prio_config_A(ipra),
      .prio_config_B(iprb),
      .prio_config_C(iprc),
      .prio_config_D(iprd),
      .vt_no(vt_no),
      .intr_ev(intr_ev));
endmodule