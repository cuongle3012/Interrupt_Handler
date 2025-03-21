// `define WAIT_CYCLES 2
module rw_control (
    input pclk,
    input preset_n,
    input psel,
    input pwrite,
    input penable,
    input ovf_trig,
    input udf_trig,
    input [7:0] paddr,
    input [7:0] pwdata,
    output [7:0] prdata,
    output pready,
    output pslverr,
    output en,
    output load,
    output updown,
    output [1:0] clr_trig,
    output [1:0] cks,
    output [7:0] tdr
);

parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b100;

reg [1:0] clr_trig_reg;
reg [2:0] sel_reg;
reg [2:0] count;
reg [7:0] tdr_reg, tcr_reg, tsr_reg;

reg pready_reg;
reg pslverr_reg;
reg [7:0] prdata_reg;

always_comb begin
        case (paddr)
            8'h00: sel_reg = A;
            8'h01: sel_reg = B;
            8'h02: sel_reg = C;
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
        tdr_reg <= 8'h00;
    else if (pwrite && psel && penable && pready && sel_reg[0])
        tdr_reg <= pwdata;
    else tdr_reg <= tdr_reg;
end

assign tdr = tdr_reg;

always @(posedge pclk or negedge preset_n) begin
    if (!preset_n)
        tcr_reg <= 8'h00;
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
            3'h2: prdata_reg = {load, 1'b0, updown, en, 2'b00, cks};
            3'h4: prdata_reg = {6'b000000, tsr_reg[1:0]};
            default: prdata_reg = 8'h00;
        endcase
    end else
        prdata_reg = prdata_reg;
end

assign prdata = prdata_reg;

// always @(posedge pclk or negedge preset_n) begin
//     if (!preset_n) begin
//         pready_reg <= 1'b0;
//         count <= 3'b000;
//     end else if (psel && penable && (!count)) begin
//         pready_reg <= 1'b0;
//     end else if (psel) begin
//         if (count == `WAIT_CYCLES) begin
//             pready_reg <= 1'b1;
//             count <= 3'b0;
//         end else begin
//             pready_reg <= 1'b0;
//             count <= count + 1'b1;
//         end
//     end else
//         pready_reg <= 1'b0;
// end

assign pready = 1;

endmodule
