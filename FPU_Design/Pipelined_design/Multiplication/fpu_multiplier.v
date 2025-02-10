`timescale 1ns / 1ps

module multiplication
#(parameter D_WIDTH = 32,
  parameter M_WIDTH = 23,
  parameter E_WIDTH = 8,
  parameter M       = 48
 )
 (
    input  [D_WIDTH-1 : 0]floating1_in,
    input  [D_WIDTH-1 : 0]floating2_in,
    output [D_WIDTH-1 : 0]floating_multiplication_out 
 );
    //Partitioning bits for sign,exponent,mantissa;
    wire                sign1,sign2;
    wire [E_WIDTH-1 : 0]exp1,exp2;
    wire [M_WIDTH-1 : 0]m1,m2;
    
    //Final sign, exponent and mantissa
    wire [E_WIDTH-1 : 0]output_exponent;
    wire [M_WIDTH-1 : 0]output_mantissa;
    wire                output_sign;
    
    //input Numbers
    assign sign1 = floating1_in[D_WIDTH-1]; //[31]
    assign exp1  = floating1_in[D_WIDTH-2 -: E_WIDTH]; //[30:23]
    assign m1    = floating1_in[M_WIDTH-1 -: M_WIDTH]; //[22:0]
    
    assign sign2 = floating2_in[D_WIDTH-1];
    assign exp2  = floating2_in[D_WIDTH-2 -: E_WIDTH];
    assign m2    = floating2_in[M_WIDTH-1 -: M_WIDTH];
    
    //Intermediate outputs
    wire [E_WIDTH : 0]exp_out;
    wire [E_WIDTH : 0]unbiased_exp_out;
    wire [M - 1   : 0]multiply_out;
    
    //Input for passing to the normalizer
    wire [E_WIDTH : 0]exp_to_the_normalizer;
    wire [M - 1   : 0]mantissa;
    
    //Outputs from the normalizer
    wire [M_WIDTH - 1 : 0] normalized_mantissa;
    wire [E_WIDTH - 1 : 0] normalized_exponent;
    
    // Exponent Addition
    nbit_adder n1(.A(exp1), .B(exp2), .Cin(1'b0), .sum(exp_out));
    
    //Unbiasing the exp_out with 127
    assign unbiased_exp_out = exp_out + (8'b1000_0000 + 1);
    
    //Multiplying the mantissas
    multiply_out = ({1'b1, m1} * {1'b1, m2});
    
    //Inputs to the Normalizer
    assign exp_to_the_normalizer = unbiased_exp_out;
    assign mantissa              = multiply_out;
    
    //Normalizer
    Normalizer n(.mantissa_from_multiplier(mantissa), .exponent_from_subtractor(exp_to_the_normalizer), .normalized_mantissa(normalized_mantissa), .normalized_exponent(normalized_exponent));

    assign output_mantissa = normalized_mantissa;
    assign output_exponent = normalized_exponent;
    assign output_sign     = sign1 ^ sign2;
    
    //Final Result
    assign floating_multiplication_out = {output_sign, output_exponent, output_mantissa};
    
endmodule
