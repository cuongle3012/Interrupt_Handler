module apb_rw(input pclk,
            input preset_n,
            input pwrite,
            input psel,
            input penable,
            input [7:0] paddr,
            input [7:0] pwdata,
            output logic [7:0] prdata,
            output pready,
            output pslverr,
            output logic [7:0] syscr,
            output logic [7:0] ipra, iprb, iprc, iprd,
            output logic [7:0] iscra, iscrb, iscrc, iscrd,
            output logic [7:0] iera, ierb,
            output logic [7:0] isra, isrb,
            output logic [7:0] tmo,
            output logic [7:0] ssr,
            input [7:0] IRQ_state, Int_IRQ_state
            );

   
   assign pready = 1'b1;      //?

   logic [14:0] psel_reg;

   always @(paddr, psel) begin
      if (psel)
         case (paddr)
            8'h00:psel_reg = 15'b000000000000001; //SYSCR
            8'h01:psel_reg = 15'b000000000000010; //IPRA
            8'h02:psel_reg = 15'b000000000000100; //IPRB
            8'h03:psel_reg = 15'b000000000001000; //IPRC
            8'h04:psel_reg = 15'b000000000010000; //IPRD
            8'h05:psel_reg = 15'b000000000100000; //IERA
            8'h06:psel_reg = 15'b000000001000000; //IERB
            8'h07:psel_reg = 15'b000000010000000; //ISCRA
            8'h08:psel_reg = 15'b000000100000000; //ISCRB
            8'h09:psel_reg = 15'b000001000000000; //ISCRC
            8'h0A:psel_reg = 15'b000010000000000; //ISCRD
            8'h0B:psel_reg = 15'b000100000000000; //ISRA
            8'h0C:psel_reg = 15'b001000000000000; //ISRB
            8'h0D:psel_reg = 15'b010000000000000; //TMO
            8'h0E:psel_reg = 15'b100000000000000; //SSR
            default: psel_reg = 15'h0;
         endcase
      else psel_reg = 15'h0;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) syscr <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[0]) syscr <= {6'b0,pwdata[1:0]};   //vậy tín hiệu TMO_EN và SLVERR_EN là gì?
      else syscr <= syscr;
   end

   //---------------Interrupt priority register---------------------------
   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) ipra <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[1]) ipra <= {1'b0,pwdata[6:4],1'b0,pwdata[2:0]};
      else ipra <= ipra;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iprb <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[2]) iprb <= {1'b0,pwdata[6:4],1'b0,pwdata[2:0]};
      else iprb <= iprb;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iprc <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[3]) iprc <= {1'b0,pwdata[6:4],1'b0,pwdata[2:0]};
      else iprc <= iprc;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iprd <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[4]) iprd <= {1'b0,pwdata[6:4],1'b0,pwdata[2:0]};
      else iprd <= iprd;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iera <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[5]) iera <= pwdata;
      else iera <= iera;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) ierb <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[6]) ierb <= pwdata;
      else ierb <= ierb;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iscra <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[7]) iscra <= pwdata;
      else iscra <= iscra;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iscrb <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[8]) iscrb <= pwdata;
      else iscrb <= iscrb;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iscrc <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[9]) iscrc <= pwdata;
      else iscrc <= iscrc;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) iscrd <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[10]) iscrd <= pwdata;
      else iscrd <= iscrd;
   end

   // IRQ Status Register have special register
   //R/W*: which means write 1 only, other value are unacceptable
   //ISRA for external interrupt, so it's depend on statue of external interrupt
   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) isra <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[11]) isra <= ~pwdata&isra;
      else isra <= isra|IRQ_state;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) isrb <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[12]) isrb <= ~pwdata&isrb;
      else isrb <= isrb|Int_IRQ_state;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) tmo <= 8'hFF;   //set về giá trị default mặc định để đếm nếu có time out
      else if (pwrite&&penable&&pready&&psel_reg[13]) tmo <= pwdata;
      else tmo <= tmo;
   end

   always @(posedge pclk, negedge preset_n) begin
      if (!preset_n) ssr <= 8'h0;
      else if (pwrite&&penable&&pready&&psel_reg[14]) ssr <= pwdata;    //vẫn được ghi bởi APB?
      else ssr <= ssr;
   end

   always @(psel_reg, penable, pwrite, pready) begin
      if (~pwrite&&penable&&pready) begin
         case (psel_reg)
            15'h0001: prdata = syscr;
            15'h0002: prdata = ipra;
            15'h0004: prdata = iprb;
            15'h0008: prdata = iprc;
            15'h0010: prdata = iprd;
            15'h0020: prdata = iera;
            15'h0040: prdata = ierb;
            15'h0080: prdata = iscra;
            15'h0100: prdata = iscrb;
            15'h0200: prdata = iscrc;
            15'h0400: prdata = iscrd;
            15'h0800: prdata = isra;
            15'h1000: prdata = isrb;
            15'h2000: prdata = tmo;
            15'h4000: prdata = ssr;
            default: prdata = 8'h0;
         endcase
      end
      else prdata = prdata;
   end

   assign pslverr = psel & !psel_reg;
endmodule