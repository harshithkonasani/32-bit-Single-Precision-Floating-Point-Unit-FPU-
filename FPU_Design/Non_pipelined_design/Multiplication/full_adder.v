`timescale 1ns / 1ps


module full_adder(
    input A,B,C,
    output sum, carry
);
    assign sum   = A ^ B ^ C;
    assign carry = (A ^ B) & C | (A & B);

endmodule
