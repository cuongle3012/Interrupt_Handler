module IMEM #(parameter SIZE = 1024)(
    input logic i_clk,
    input logic in_rst,
    input logic [31:0] pc,
    output logic [31:0] instr
);

    logic [31:0] memory [0:SIZE-1];
    assign instr = memory[pc[13:2]];

    initial begin
        // $readmemh("D:/chiase/pipeline/NO_SRAM/Forwarding_self/02_test/dump/lcd16.txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/tb/New Text Document.txt", memory);
        //  $readmemh("D:/chiase/RISC_Interrupt/tb/program4kit_NOSRAM.txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/doan/01_tb/uarthex.txt", memory);
        // $readmemh("/mnt/hgfs/chiase/RISC_Interrupt/tb/SRAM_success/test_me.txt", memory);
        $readmemh("D:/chiase/RISC_Interrupt/tb/program4kit(1).txt", memory);

    end
endmodule
