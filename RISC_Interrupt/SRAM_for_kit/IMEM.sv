module IMEM #(parameter SIZE = 2048)(
    input logic i_clk,
    input logic in_rst,
    input logic [31:0] pc,
    output logic [31:0] instr
);

    logic [31:0] memory [0:SIZE-1];
    assign instr = memory[pc[13:2]];

    initial begin
        $readmemh("D:/chiase/RISC_Interrupt/tb/program4kit_NOSRAM.txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/tb/tmr_exthex.txt", memory);
        // $readmemh("D:/chiase/RISC_Interrupt/tb/SRAM_success/SRAM_hex.txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/SRAM_for_sim/01_tb/uarthex.txt", memory);
    end
endmodule
