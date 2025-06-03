module SRAM (
    input logic clk, rst,

    inout wire [15:0] SRAM_DQ, // Bus dữ liệu IN/OUT

    input logic [17:0] SRAM_ADDR,
    input logic SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N
);

    // Mô phỏng bộ nhớ SRAM (64 ô nhớ 16-bit)
    reg [15:0] MEM[8192];

    integer i;

    // Reset bộ nhớ
    always @(posedge rst) begin
        if (rst) begin
            for (i = 0; i <= 8192; i = i + 1) begin
                MEM[i] <= 16'b0;
            end
        end
    end

    // Ghi dữ liệu vào bộ nhớ SRAM
    always @(posedge clk) begin
        if (~SRAM_WE_N && ~SRAM_CE_N) begin // Kiểm tra tín hiệu Chip Enable (SRAM_CE_N = 0)
            if (~SRAM_LB_N) // Ghi byte thấp (8-bit)
                MEM[SRAM_ADDR][7:0] <= SRAM_DQ[7:0];

            if (~SRAM_UB_N) // Ghi byte cao (8-bit)
                MEM[SRAM_ADDR][15:8] <= SRAM_DQ[15:8];
        end
    end

    // Đọc dữ liệu từ bộ nhớ SRAM
    assign SRAM_DQ = (~SRAM_WE_N || SRAM_CE_N || SRAM_OE_N) ? 16'bz : 
                     { (~SRAM_UB_N ? MEM[SRAM_ADDR][15:8] : 8'bz),
                       (~SRAM_LB_N ? MEM[SRAM_ADDR][7:0]  : 8'bz) };

endmodule
