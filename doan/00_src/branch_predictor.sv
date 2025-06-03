`define STRONG_TAKEN       2'b11
`define WEAK_TAKEN         2'b10
`define WEAK_NOT_TAKEN     2'b01
`define STRONG_NOT_TAKEN   2'b00

`define R_type          7'b0110011
`define I_type          7'b0010011
`define I_type_load     7'b0000011
`define JAL             7'b1101111
`define JALR            7'b1100111
`define S_type          7'b0100011
`define B_type          7'b1100011
`define LUI             7'b0110111
`define AUIPC           7'b0010111

module branch_predictor(
    input logic i_clk,
    input logic i_rst_n,
    //inputs
    input logic [31:0] i_alu_data, // PC value is calculated by ALU module (get from alu_data_o)
   //  input logic [31:0] instr_IF,
    input logic [31:0] instr_EX,
    input logic [31:0] pc_IF, //use for jump instruction index when read
    input logic [31:0] pc_EX, //use for jump instruction index when write
    input logic i_taken, //1 if jump is correct, 0 if jump is wrong (get from br_sel_o)
    //outputs
    output logic [31:0] o_pc,
    output logic o_pc_sel_BTB,
    output logic o_mispred    
);
    logic [31:0] predicted_pc [32];
    logic [24:0] tag [32];
    bit [1:0] state [32]; //00 01 10 11
    //Address of buffer
    logic [4:0] index_W;
    logic [4:0] index_R;
    assign index_W = pc_EX[6:2];
    assign index_R = pc_IF[6:2];
    //-----------------------------------------------------------------------------------------------------//

    //    //FSM CHO TRẠNG THÁI
//    always @(posedge i_clk, negedge i_rst_n) begin
//       for (int i=0;i<128;i++) begin
//          if (!i_rst_n) state[index_W] <= `STRONG_NOT_TAKEN;
//          else state[index_W] <= next_state[index_W];
//       end
//    end

//    //--> 0 được xài của chung, nếu xài của chung, thằng khác nó nhảy vô làm bị

//    always_comb begin
//       case (state[index_W])
//          `STRONG_NOT_TAKEN: next_state[index_W] = i_taken ? `WEAK_NOT_TAKEN : `STRONG_NOT_TAKEN; //giảm lại nếu đoán sai lần 1
//          `WEAK_NOT_TAKEN: next_state[index_W] = i_taken? `WEAK_TAKEN : `STRONG_NOT_TAKEN; //giảm lại nếu đoán sai lần 1
//          `WEAK_TAKEN: next_state[index_W] = i_taken? `STRONG_TAKEN : `WEAK_NOT_TAKEN; //giảm lại nếu đoán sai lần 1
//          `STRONG_TAKEN: next_state[index_W] = i_taken? `STRONG_TAKEN : `WEAK_TAKEN; //giảm lại nếu đoán sai lần 1
//          default: next_state[index_W] = `STRONG_NOT_TAKEN;
//       endcase
//    end

//    //Ghi data vào BTB
//    always_ff @(posedge i_clk) begin
//       if ((instr_EX[6:0] == `B_type)||(instr_EX[6:0] == `JAL)||(instr_EX[6:0] == `JALR)) begin
//          tag[index_W] <= pc_EX[31:9];
//          predicted_pc[index_W] <= i_alu_data;
//       end
//    end

    //Write the branch info if find no branch info in the buffer
    always_ff @(posedge i_clk) begin
        if (((instr_EX[6:0] == `B_type)||(instr_EX[6:0] == `JAL)||(instr_EX[6:0] == `JALR))&i_taken) begin
            tag[index_W] <= pc_EX[31:7];
            predicted_pc[index_W] <= i_alu_data;
            if (state[index_W] == `STRONG_NOT_TAKEN) begin
                state[index_W] <= `WEAK_NOT_TAKEN;
            end 
            else if (state[index_W] == `WEAK_NOT_TAKEN) begin
                state[index_W] <= `STRONG_TAKEN;
            end
            else if (state[index_W] == `WEAK_TAKEN) begin
                state[index_W] <= `STRONG_TAKEN;
            end
            else if (state[index_W] == `STRONG_TAKEN) begin
                state[index_W] <= `STRONG_TAKEN;
            end
        end
        else if (((instr_EX[6:0] == `B_type)||(instr_EX[6:0] == `JAL)||(instr_EX[6:0] == `JALR))&!i_taken) begin
            tag[index_W] <= pc_EX[31:7];
            predicted_pc[index_W] <= i_alu_data;
            if (state[index_W] == `STRONG_NOT_TAKEN) begin
                state[index_W] <= `STRONG_NOT_TAKEN;
            end 
            else if (state[index_W] == `WEAK_NOT_TAKEN) begin
                state[index_W] <= `STRONG_NOT_TAKEN;
            end
            else if (state[index_W] == `WEAK_TAKEN) begin
                state[index_W] <= `STRONG_NOT_TAKEN;
            end
            else if (state[index_W] == `STRONG_TAKEN) begin
                state[index_W] <= `WEAK_TAKEN;
            end
        end
    end
    //Read the branch info in the buffer
    always_comb begin
        if (!i_rst_n) begin
            o_pc = 32'd0;
            o_pc_sel_BTB = 1'b0;
            o_mispred = 1'b1;
        end else begin
            if ((pc_IF[31:7] == tag[index_R]) && (state[index_R] == `WEAK_TAKEN || state[index_R] == `STRONG_TAKEN)) begin
                o_pc = predicted_pc[index_R];
                o_pc_sel_BTB = 1'b1; //predicted PC
                o_mispred = 1'b0;   //đoán đúng thì khớp vào
            end
            else begin
                // o_pc = 32'd0;
                o_pc = pc_IF + 32'h4;
                o_pc_sel_BTB = 1'b0; //PC + 4
                o_mispred = 1'b1;   //đoán sai thì 0
            end
        end
    end
endmodule