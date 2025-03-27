// `define WAIT_CYCLES 2
module rw_control (
    input pclk,
    input preset_n,
    input psel,
    input pwrite,
    input penable,
    input ovf_trig,
    input udf_trig,
    input [31:0] paddr,
    input [31:0] pwdata,
    output [31:0] prdata,
    output pready,
    output pslverr,
    output en,
    output load,
    output updown,
    output [1:0] clr_trig,
    output [1:0] cks,
    output [31:0] tdr
);

parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b100;

reg [1:0] clr_trig_reg;
reg [2:0] sel_reg;
reg [2:0] count;
reg [31:0] tdr_reg, tcr_reg, tsr_reg;

reg pready_reg;
reg pslverr_reg;
reg [31:0] prdata_reg;

always_comb begin
        case (paddr)
            32'h00000000: sel_reg = A;
            32'h00000004: sel_reg = B;
            32'h00000008: sel_reg = C;
            default: sel_reg = 3'h0;
        endcase
    end

assign pslverr = pslverr_reg;

always @(posedge pclk or negedge preset_n) begin
    if (!preset_n)
        pslverr_reg <= 1'b0;
    else if (!sel_reg)
        pslverr_reg <= 1'b1;
    else
        pslverr_reg <= pslverr_reg;
end

always @(posedge pclk or negedge preset_n) begin
    if (!preset_n)
        tdr_reg <= 32'b0;
    else if (pwrite && psel && penable && pready && sel_reg[0])
        tdr_reg <= pwdata;
    else tdr_reg <= tdr_reg;
end

assign tdr = tdr_reg;

always @(posedge pclk or negedge preset_n) begin
    if (!preset_n)
        tcr_reg <= 32'd0;
    else if (pwrite && psel && penable && pready && sel_reg[1]) begin
        tcr_reg[7] <= pwdata[7];
        tcr_reg[5] <= pwdata[5];
        tcr_reg[4] <= pwdata[4];
        tcr_reg[1:0] <= pwdata[1:0];
    end
    else tcr_reg <= tcr_reg;
end

// Output for internal module -> connect Timer Counter
assign load = tcr_reg[7];
assign en = tcr_reg[4];
assign updown = tcr_reg[5];
assign cks = tcr_reg[1:0];

always @(posedge pclk or negedge preset_n) begin
    if (!preset_n)
        tsr_reg[0] <= 1'b0;
    else if (psel && penable && pready && sel_reg[2] && (!pwdata[0]))
        tsr_reg[0] <= 1'b0;
    else if (ovf_trig)
        tsr_reg[0] <= 1'b1;
    else if (clr_trig_reg[0])
        tsr_reg[0] <= 1'b0;
    else tsr_reg[0] <= tsr_reg[0];
end

always @(posedge pclk or negedge preset_n) begin
    if (!preset_n)
        tsr_reg[1] <= 1'b0;
    else if (psel && penable && pready && sel_reg[2] && (!pwdata[1]))
        tsr_reg[1] <= 1'b0;
    else if (udf_trig)
        tsr_reg[1] <= 1'b1;
    else if (clr_trig_reg[1])
        tsr_reg[1] <= 1'b0;
    else tsr_reg[1] <= tsr_reg[1];
end

assign clr_trig = clr_trig_reg;

always @(*) begin
    if (psel && penable && (!pwrite) && pready) begin
        case (sel_reg)
            3'h1: prdata_reg = tdr_reg;
            3'h2: prdata_reg = {24'b0,load, 1'b0, updown, en, 2'b00, cks};
            3'h4: prdata_reg = { 30'b0,tsr_reg[1:0]};
            default: prdata_reg = 32'b0;
        endcase
    end else
        prdata_reg = prdata_reg;
end

assign prdata = prdata_reg;


assign pready = 1;

endmodule
