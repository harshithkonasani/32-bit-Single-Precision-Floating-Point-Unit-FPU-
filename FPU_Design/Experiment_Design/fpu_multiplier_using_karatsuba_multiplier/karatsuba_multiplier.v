`timescale 1ns / 1ps


module karatsuba_2 #(
    parameter integer DATA_WIDTH = 24,  // Works for 24-bit floating-point mantissa multiplication
    parameter integer HALF_WIDTH = DATA_WIDTH / 2
)(
    input  wire [DATA_WIDTH-1:0] a_in,
    input  wire [DATA_WIDTH-1:0] b_in,
    
    output wire [2*DATA_WIDTH-1:0] multi_out
);

    // Split inputs into high and low parts
    wire [HALF_WIDTH-1:0] a_high, a_low, b_high, b_low;
    assign {a_high, a_low} = a_in;
    assign {b_high, b_low} = b_in;

    // Compute three key multiplications
    wire [DATA_WIDTH-1:0] P1, P2, P3, sum_a, sum_b, cross_mult;
    
    assign P1 = a_high * b_high;  // High part product
    assign P2 = a_low * b_low;    // Low part product
    
    assign sum_a = a_high + a_low;  // A_H + A_L
    assign sum_b = b_high + b_low;  // B_H + B_L
    assign cross_mult = sum_a * sum_b; // (A_H + A_L) * (B_H + B_L)
    
    assign P3 = cross_mult - P1 - P2; // Middle term correction
    
    // Final product reconstruction
    wire [2*DATA_WIDTH-1:0] stage1, stage2, stage3;
    
    assign stage1 = {P1, {DATA_WIDTH{1'b0}}};       // Shift P1 left by DATA_WIDTH
    assign stage2 = { {HALF_WIDTH{1'b0}}, P3, {HALF_WIDTH{1'b0}} };  // Shift P3 left by HALF_WIDTH
    assign stage3 = { {DATA_WIDTH{1'b0}}, P2 };    // P2 remains in lower bits

    // Final multiplication result
    assign multi_out = stage1 + stage2 + stage3;

endmodule
