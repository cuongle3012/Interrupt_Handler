module PCNEXT (input i_clk,
               input i_rst_n,
               input status_IF, status_EX,
               input [1:0] pc_src,
               input pc_sel,
               input [31:0] pc_trap,
               input [31:0] mepc,
               input [31:0] br_pc_real, pc_real,
               output logic [31:0] nxt_pc);

   localparam PC_RESET = 2'b00;
   localparam PC_TRAP = 2'b01;
   localparam PC_EPC = 2'b10;
   localparam PC_NEXT = 2'b11;
   


   always_comb begin
      if (pc_src == PC_RESET) nxt_pc = 32'b0;
      else if (pc_src == PC_TRAP) nxt_pc = pc_trap;
      else if (pc_src == PC_EPC) nxt_pc = mepc;
      else nxt_pc = pc_sel&!(status_IF^status_EX)? br_pc_real : pc_real + 32'h4;
   end


endmodule