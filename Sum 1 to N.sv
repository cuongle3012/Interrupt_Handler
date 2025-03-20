module pipeline_tb;

   //------------------ Signal Declaration ------------------
   // Inputs:
   reg        i_clk;
   reg        i_rst_n;
   reg [31:0] i_io_sw;
   reg [3:0]  i_io_btn;

   // Outputs:
   wire [31:0] o_pc_debug;
   wire        o_insn_vld;
   wire [31:0] o_io_ledr;
   wire [31:0] o_io_ledg;
   wire [6:0]  o_io_hex0;
   wire [6:0]  o_io_hex1;
   wire [6:0]  o_io_hex2;
   wire [6:0]  o_io_hex3;
   wire [6:0]  o_io_hex4;
   wire [6:0]  o_io_hex5;
   wire [6:0]  o_io_hex6;
   wire [6:0]  o_io_hex7;
   wire [31:0] o_io_lcd;

   // Variables for tracking
   integer zero_time_count;         // Time count (in terms of cycles) where o_pc_debug = 0 after a change
   integer total_time_after_change; // Total time (in terms of cycles) from transition to o_pc_debug == 0 until program ends
   reg [31:0] prev_pc_debug;       // Previous value of o_pc_debug
   reg pc_debug_was_non_zero;      // Flag to check if o_pc_debug was non-zero before
   integer cycle_count;            // Total cycle count for time calculation

   // Variables for tracking o_io_ledr changes
   reg [31:0] prev_ledr;           // Previous value of o_io_ledr
   reg ledr_changed;               // Flag to detect change in o_io_ledr
   integer ledr_change_time;       // Time (in cycles) when o_io_ledr changed

   // Variable for Number of Instructions
   integer num_of_instructions;    // The difference between ledr_change_time and zero_time_count
   real ipc;                       // Instructions per cycle (IPC)

   //------------------ Clock generation ------------------
   always #5 i_clk = ~i_clk;

   pipeline DUT (
       .i_clk (i_clk),
       .i_rst_n (i_rst_n),
       .i_io_sw (i_io_sw),
       .o_pc_debug (o_pc_debug),
       .o_insn_vld (o_insn_vld),
       .o_io_ledr (o_io_ledr),
       .o_io_ledg (o_io_ledg),
       .o_io_hex0 (o_io_hex0),
       .o_io_hex1 (o_io_hex1),
       .o_io_hex2 (o_io_hex2),
       .o_io_hex3 (o_io_hex3),
       .o_io_hex4 (o_io_hex4),
       .o_io_hex5 (o_io_hex5),
       .o_io_hex6 (o_io_hex6),
       .o_io_hex7 (o_io_hex7),
       .o_io_lcd  (o_io_lcd)
   );

   //------------------ Simulation Logic ------------------
   initial begin
       $shm_open("wave.shm");
       i_rst_n = 0;
       i_clk = 1;
       zero_time_count = 0;
       total_time_after_change = 0;
       prev_pc_debug = 32'h0;
       pc_debug_was_non_zero = 0;
       cycle_count = 0;
       prev_ledr = 32'h0;
       ledr_changed = 0;
       ledr_change_time = 0;
       num_of_instructions = 0;
       ipc = 0.0;

       // Reset CPU
       #20 i_rst_n = 1;
       $display("Non-Forwarding CPU");
       $display("Test: Sum 1 to N");
       i_io_sw = 100;
       $display("Input number: %0d", i_io_sw);
       #20000;  // Chạy mô phỏng trong 20.000 chu kỳ

       // Calculate IPC if instructions are counted
       if (ledr_changed && zero_time_count != 0 && total_time_after_change > 0) begin
           num_of_instructions = ledr_change_time - zero_time_count;
       end
       // Display the results
       $display("Number of Non-Instructions: %0d ", zero_time_count);
       $display("Number of Cycle: %0d", ledr_change_time);
       $display("Number of Instructions: %0d", num_of_instructions);
$finish;
   end

   // Logic for tracking o_pc_debug behavior
   always @(posedge i_clk or negedge i_rst_n) begin
       if (!i_rst_n) begin
           zero_time_count <= 0;
           total_time_after_change <= 0;
           prev_pc_debug <= 32'h0;
           pc_debug_was_non_zero <= 0;
           cycle_count <= 0;
       end else begin
           // Detect transition from 0 to non-zero
           if (prev_pc_debug == 0 && o_pc_debug != 0) begin
               pc_debug_was_non_zero <= 1;  // Flag that o_pc_debug has moved from 0 to non-zero
           end

           // Count time (cycles) where o_pc_debug is 0 after changing from non-zero
           if (pc_debug_was_non_zero && o_pc_debug == 0) begin
               zero_time_count <= zero_time_count + 1;
           end

           // Count total time (cycles) from the moment o_pc_debug changed to non-zero until it became 0
           if (pc_debug_was_non_zero) begin
               total_time_after_change <= total_time_after_change + 1;
           end

           // Update previous value
           prev_pc_debug <= o_pc_debug;

           // Increment total cycle count for time calculation
           cycle_count <= cycle_count + 1;
       end
   end

   // Logic for tracking o_io_ledr behavior
   always @(posedge i_clk or negedge i_rst_n) begin
       if (!i_rst_n) begin
           prev_ledr <= 32'h0;
           ledr_changed <= 0;
           ledr_change_time <= 0;
       end else begin
           // Detect change in o_io_ledr
           if (prev_ledr != o_io_ledr && !ledr_changed) begin
               ledr_changed <= 1;
               ledr_change_time <= cycle_count;
               $display("Output: %0d", o_io_ledr);
           end

           // Update previous value of o_io_ledr
           prev_ledr <= o_io_ledr;
       end
   end

endmodule
