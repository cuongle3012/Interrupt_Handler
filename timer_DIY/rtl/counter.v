module counter(input pclk,
               input preset_n,
               input load,
               input en,		//tin hieu en cua thanh ghi TCR
               input updw,
	       input clk_int,
	       input [7:0] tdr,
               output [7:0] cnt,
	       output [7:0] last_cnt
               );

reg [7:0] last_cnt_reg, cnt_reg;
reg sub_en, add_en;
reg [7:0] cnt_a;	//dau vao cua phep cong 1
reg [7:0] cnt_s;	//dau vao cua phep tru 1
reg [7:0] cnt_ra;
wire [7:0] cnt_ra_temp;	//ket qua cua phep cong 1
reg [7:0] cnt_rs;
wire [7:0] cnt_rs_temp;	//ket qua cua phep tru 1
wire [7:0] c1, c2;		//bit nho cua phep cong cung nhu tru

reg last_clk_int;
wire cnt_en;

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) last_clk_int <= 1'b0;
	else last_clk_int <= clk_int;
	end

assign cnt_en = (!last_clk_int) & clk_int;

always @(negedge pclk) begin
	if (preset_n) begin		//ban chat la chung voi module o duoi, nhung tach ra de tranh bi xung dot tin hieu
	   if (!updw && add_en) cnt_reg <= cnt_ra;	// nen phai tach ra de tranh bi xung dot tin hieu
	   else if (updw && sub_en) cnt_reg <= cnt_rs;
	   else cnt_reg <= cnt_reg;
	   if (add_en) add_en <= 1'b0;
	   if (sub_en) sub_en <= 1'b0;
	   end
end

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n) begin
	   cnt_reg <= 8'h00;
	   add_en <= 1'b0;
	   sub_en <= 1'b0;
	end
	else if (load) begin
	   cnt_reg <= tdr;
	   add_en <= 1'b0;
	   sub_en <= 1'b0;
	end
	else if (en && cnt_en) begin
	    if (updw) begin
	    	sub_en <= 1'b1;
		cnt_s <= cnt_reg;
	//	cnt_reg <= cnt_rs;		//viet nhu vay thi se thuc hien viec gan ca 3 cung 1 luc(do day la lenh non blocking)
	    end
	    else begin
	    	add_en <= 1'b1;
		cnt_a <= cnt_reg;
	//	cnt_reg <= cnt_ra;
	    end
	end
	else begin
	   cnt_reg <= cnt_reg;
	   add_en <= 1'b0;
	   sub_en <= 1'b0;
	end
end

assign cnt = cnt_reg;

always @(negedge pclk or negedge preset_n) begin
	if (!preset_n) last_cnt_reg <= 8'h00;
//	else if (add_en || sub_en) last_cnt_reg <= cnt_reg;
	else last_cnt_reg <= cnt_reg;	//muc dich la luu lai gia tri cnt truoc do, du counter co cong hay 0
end

assign last_cnt = last_cnt_reg;

generate

for (genvar i=0;i<8;i=i+1)
   	begin
   	   if (!i) half_adder ha(.S(cnt_ra_temp[0]),.Cout(c1[0]),.A(cnt_a[0]),.B(1'b1));
   	   else full_adder fa(.S(cnt_ra_temp[i]),.Cout(c1[i]),.A(cnt_a[i]),.B(1'b0),.Cin(c1[i-1]));
   	end

   for (genvar j=0;j<8;j=j+1)
   	begin
   	   if (!j) half_adder ha(.S(cnt_rs_temp[0]),.Cout(c2[0]),.A(cnt_s[0]),.B(1'b1));
   	   else full_adder fa(.S(cnt_rs_temp[j]),.Cout(c2[j]),.A(cnt_s[j]),.B(1'b1),.Cin(c2[j-1]));
   	end

always @(posedge add_en or posedge sub_en) begin
	if (add_en) begin
	   cnt_ra = cnt_ra_temp;
	   cnt_rs = 8'h00;
	end
	else if (sub_en) begin
	   cnt_ra = 8'h00;
	   cnt_rs = cnt_rs_temp;
	end
	else begin
	   cnt_ra = 8'h00;
	   cnt_rs = 8'h00;
	end
end
endgenerate
/*
half_adder ha0(.S(cnt_ra_reg[0]),.C(c1[0]),.A(cnt_a[0]),.B(1'b1));
full_adder fa01(.S(cnt_ra_reg[1]),.C(c1[1]),.A(cnt_a[1]),.B(1'b0),.Cin(c1[0]));
full_adder fa11(.S(cnt_ra_reg[2]),.C(c1[2]),.A(cnt_a[2]),.B(1'b0),.Cin(c1[1]));
full_adder fa21(.S(cnt_ra_reg[3]),.C(c1[3]),.A(cnt_a[3]),.B(1'b0),.Cin(c1[2]));
full_adder fa31(.S(cnt_ra_reg[4]),.C(c1[4]),.A(cnt_a[4]),.B(1'b0),.Cin(c1[3]));
full_adder fa41(.S(cnt_ra_reg[5]),.C(c1[5]),.A(cnt_a[5]),.B(1'b0),.Cin(c1[4]));
full_adder fa51(.S(cnt_ra_reg[6]),.C(c1[6]),.A(cnt_a[6]),.B(1'b0),.Cin(c1[5]));
full_adder fa61(.S(cnt_ra_reg[7]),.C(c1[7]),.A(cnt_a[7]),.B(1'b0),.Cin(c1[6]));

always @(add_en) begin
cnt_ra = add_en ? cnt_ra_reg : 8'h00;
end

half_adder ha1(.S(cnt_rs_reg[0]),.C(c2[0]),.A(cnt_s[0]),.B(1'b1));
full_adder fa02(.S(cnt_rs_reg[1]),.C(c2[1]),.A(cnt_s[1]),.B(1'b1),.Cin(c2[0]));
full_adder fa12(.S(cnt_rs_reg[2]),.C(c2[2]),.A(cnt_s[2]),.B(1'b1),.Cin(c2[1]));
full_adder fa22(.S(cnt_rs_reg[3]),.C(c2[3]),.A(cnt_s[3]),.B(1'b1),.Cin(c2[2]));
full_adder fa32(.S(cnt_rs_reg[4]),.C(c2[4]),.A(cnt_s[4]),.B(1'b1),.Cin(c2[3]));
full_adder fa42(.S(cnt_rs_reg[5]),.C(c2[5]),.A(cnt_s[5]),.B(1'b1),.Cin(c2[4]));
full_adder fa52(.S(cnt_rs_reg[6]),.C(c2[6]),.A(cnt_s[6]),.B(1'b1),.Cin(c2[5]));
full_adder fa62(.S(cnt_rs_reg[7]),.C(c2[7]),.A(cnt_s[7]),.B(1'b1),.Cin(c2[6]));

always @(sub_en) begin
cnt_rs = sub_en ? cnt_rs_reg : 8'h00;
end
*/
endmodule
