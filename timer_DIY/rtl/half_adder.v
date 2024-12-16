module half_adder (input A,
                   input B,
                   output Cout,
                   output S
                   );

assign S = A ^ B;
assign Cout = A&B;

endmodule
