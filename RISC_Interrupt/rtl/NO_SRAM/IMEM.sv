module IMEM #(parameter SIZE = 1024)(
    input logic i_clk,
    input logic in_rst,
    input logic [31:0] pc,
    output logic [31:0] instr
);

    bit [31:0] memory [0:SIZE-1];
    assign instr = memory[pc[13:2]];

    initial begin
        $readmemh("D:/chiase/RISC_Interrupt/tb/program4kit(1).txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/tb/test_sim.txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/tb/chuongtrinhtest_hex.txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/tb/test_INT3_hex.txt", memory);
    end
endmodule
