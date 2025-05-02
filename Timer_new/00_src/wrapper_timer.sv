module wrapper_timer(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        psel,
    input  logic        pwrite,
    input  logic        penable,
    input  logic [31:0] pwdata,
    input  logic [31:0] paddr,
    output logic [31:0] prdata,
    output logic        pready,
    output logic        pslverr,
    output logic        intr_timer
);

    // Chốt đầu vào
    logic        psel_reg;
    logic        pwrite_reg;
    logic        penable_reg;
    logic [31:0] pwdata_reg;
    logic [31:0] paddr_reg;

    // Tín hiệu từ module timer
    logic [31:0] prdata_wire;
    logic        pready_wire;
    logic        pslverr_wire;
    logic        intr_timer_wire;

    // Register đầu vào
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            psel_reg     <= 1'b0;
            pwrite_reg   <= 1'b0;
            penable_reg  <= 1'b0;
            pwdata_reg   <= 32'd0;
            paddr_reg    <= 32'd0;
        end else begin
            psel_reg     <= psel;
            pwrite_reg   <= pwrite;
            penable_reg  <= penable;
            pwdata_reg   <= pwdata;
            paddr_reg    <= paddr;
        end
    end

    // Register đầu ra
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prdata      <= 32'd0;
            pready      <= 1'b0;
            pslverr     <= 1'b0;
            intr_timer  <= 1'b0;
        end else begin
            prdata      <= prdata_wire;
            pready      <= pready_wire;
            pslverr     <= pslverr_wire;
            intr_timer  <= intr_timer_wire;
        end
    end

    // Instantiation of timer module
    timer timer (
        .pclk       (clk),
        .preset_n   (rst_n),
        .psel       (psel_reg),
        .pwrite     (pwrite_reg),
        .penable    (penable_reg),
        .pwdata     (pwdata_reg),
        .paddr      (paddr_reg),
        .prdata     (prdata_wire),
        .pready     (pready_wire),
        .pslverr    (pslverr_wire),
        .intr_timer (intr_timer_wire)
    );

endmodule
