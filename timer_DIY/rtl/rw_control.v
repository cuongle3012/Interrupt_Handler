`define WAIT_CYCLES 2
module rw_control (input pclk,
                   input preset_n,
                   input psel,
                   input penable,
                   input pwrite,
		   input ovf_trig,
		   input udf_trig,
                   input [7:0] paddr,
                   input [7:0] pwdata,
                   output [7:0] prdata,
                   output pready,
                   output pslverr,
		   output load,
		   output updw,
		   output en,
		   output [1:0] cks,
		   output [7:0] tdr,
		   output [1:0] clr_trig
                   );
reg [1:0] clr_trig_reg;

// Khai bao thong so dia chi trung gian

parameter TDR = 3'h1;
parameter TCR = 3'h2;
parameter TSR = 3'h4;

// Khai bao khoi thanh ghi
reg [2:0] cnt_i, cnt_o;
wire [2:0] carry, cnt_o_temp;
reg pslverr_reg;
reg pready_reg;
reg add_en;
reg [7:0] prdata_reg;
reg [7:0] tdr_reg, tcr_reg, tsr_reg;

//co document gom cac register, chuc nang cua register, tung bit trong do bieu thi chuc nang gi, la 1 design thi viet cmt cang chi tiet cang tot, nen ghi thanh ghi nay co chuc nang gi, ten gi, gom lai chuc nang cua thanh ghi roi o duoi ghi dung chuc nang do cho de kiem soat

// Khai bao thanh ghi trung gian
reg [2:0] sel_reg;
reg [2:0] count;
// kich tin hieu sai dia chi

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) pslverr_reg <= 1'b0;
	else if (!sel_reg) pslverr_reg <= 1'b1;
	else pslverr_reg <= 1'b0;
end

assign pslverr = pslverr_reg;

// chon thanh ghi minh can ghi du lieu vao

always @(paddr) begin
	case (paddr)
	8'h00: sel_reg = TDR;
	8'h01: sel_reg = TCR;
	8'h02: sel_reg = TSR;
	default: sel_reg = 3'h0;
	endcase
end

// ghi du lieu truyen vao TDR_reg

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) tdr_reg <= 8'h00;
	else if (psel && penable && pwrite && pready && sel_reg[0]) tdr_reg <= pwdata;
	else tdr_reg <= tdr_reg;
end

assign tdr = tdr_reg;

// ghi du lieu truyen vao TCR_reg
assign load = tcr_reg[7];
assign updw = tcr_reg[5];
assign en = tcr_reg[4];
assign cks = tcr_reg[1:0];

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) tcr_reg <= 8'h00;
	else if (psel && penable && pwrite && pready && sel_reg[1]) begin
	    tcr_reg[7] <= pwdata[7];
	    tcr_reg[5] <= pwdata[5];
	    tcr_reg[4] <= pwdata[4];
            tcr_reg[1:0] <= pwdata[1:0];
	end
	else tcr_reg <= tcr_reg;
end

/*always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) TSR_reg <= 8'h00;
	else if (psel && penable && pwrite && pready && sel_reg[2]) TSR_reg <= pwdata;
	else TSR_reg <= TSR_reg;
end*/

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) begin
	tsr_reg[0] <= 1'b0;
	clr_trig_reg[0] <= 1'b0;
	end
	else if (psel && penable && sel_reg[2] && pready && (!pwdata[0])) begin	//dieu kien W*= dieu kien ghi + dieu kien data	//clear by software
// !pwdata[0] = (pwdata[1:0] != 2'b11) && ((!TSR_reg[1]) ||TSR_reg[1] &&(!pwdata[0]))?????
	tsr_reg[0] <= 1'b0;
	clr_trig_reg[0] <= 1'b0;
	end
	else if (ovf_trig) begin	//set 1 by hardware
	tsr_reg[0] <= 1'b1;
	clr_trig_reg[0] <= 1'b1;
	end
	else begin	//no action for HW or SW
	tsr_reg[0] <= tsr_reg[0];
	clr_trig_reg[0] <= clr_trig_reg[0];
	end
end
// hardware dua ra la udf/ovf_trig(tu bo compare), roi thanh ghi bat duoc tin hieu do luu lai roi dua tin hieu cua thanh ghi xuat ra cho ben compare
always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) begin
	tsr_reg[1] <= 1'b0;
	clr_trig_reg[1] <= 1'b0;
	end
	else if (psel && penable && sel_reg[2] && pready && (!pwdata[1])) begin
	tsr_reg[1] <= 1'b0;
	clr_trig_reg[1] <= 1'b0;
	end
	else if (udf_trig) begin
	tsr_reg[1] <= 1'b1;
	clr_trig_reg[1] <= 1'b1;
	end
	else begin
	tsr_reg[1] <= tsr_reg[1];
	clr_trig_reg[1] <= clr_trig_reg[1];
	end
end

assign clr_trig = clr_trig_reg;

// set tin hieu cho pready

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) begin
	   pready_reg <= 1'b0;
	   count <= 3'b000;
	   add_en <= 1'b0;
	end
	else if (psel && penable && (!count)) begin	//buoc vao trang thai end of access
	    add_en <= 1'b0;
	    #1;
	    pready_reg <= 1'b0;
        end
	else if (psel) begin				//neu 0 phai thi xet thu xem co bat dau vao access duoc chua
	     if (count == `WAIT_CYCLES) begin		//da delay xong, ta kich tin hieu pready de ket thuc qua trinh truyen du lieu
	        count <= 3'b000;
		add_en <= 1'b0;
	        #1;
	        pready_reg <= 1'b1;
	     end else begin				//chua dem xong, tiep tuc dem
	        pready_reg <= 1'b0;
	        add_en <= 1'b1;
		cnt_i <= count;
		count <= cnt_o;
		#10;
		add_en <= 1'b0;
	     end
	end
	else begin
	  pready_reg <= 1'b0;
	  add_en <= 1'b0;
	end
end

assign pready = pready_reg;

always @(*) begin
	if (psel && penable && pready && (!pwrite)) begin
	    case (sel_reg)
	    3'h1: prdata_reg <= tdr_reg;
	    3'h2: prdata_reg <= {load, 1'b0, updw, en, 2'b00, cks};	// co che bao ve dau ra, co lap cac bit reserved
	    3'h4: prdata_reg <= {6'h00, tsr_reg[1:0]};
	    default: prdata_reg <= 8'h00;
	    endcase
	end else prdata_reg <= prdata_reg;
end

assign prdata = prdata_reg;

half_adder ha(.S(cnt_o_temp[0]),.Cout(carry[0]),.A(cnt_i[0]),.B(1'b1));
full_adder fa1(.S(cnt_o_temp[1]),.Cout(carry[1]),.A(cnt_i[1]),.B(1'b0),.Cin(carry[0]));
full_adder fa2(.S(cnt_o_temp[2]),.Cout(carry[2]),.A(cnt_i[2]),.B(1'b0),.Cin(carry[1]));

always @(posedge add_en) cnt_o = add_en ? cnt_o_temp : 3'b0;

endmodule
