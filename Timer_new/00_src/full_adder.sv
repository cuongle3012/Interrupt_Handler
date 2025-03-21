module full_adder (input A,
                   input B,
                   input Cin,
                   output S,
                   output Cout
                   );

wire I1, I2, I3;

half_adder ha1(.A(A),.B(B),.Cout(I2),.S(I1));
half_adder ha2(.A(I1),.B(Cin),.Cout(I3),.S(S));

assign Cout = I2 || I3;

endmodule