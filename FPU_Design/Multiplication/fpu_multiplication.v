`timescale 1ns / 1ps

module fp_multiplier#
(
	parameter integer DATA_WIDTH = 32,
	parameter integer MENT_WIDTH = 23,
	parameter integer EXPO_WIDTH = 8,
    parameter integer RES_WIDTH = 48
)
(
    input [DATA_WIDTH-1:0] floating1_in, 
    input [DATA_WIDTH-1:0] floating2_in,
    output [DATA_WIDTH-1:0] multi_out,
    output except
);

    //Extracting sign from input
    wire s1 = floating1_in[DATA_WIDTH-1]; //bit [31]
    //Extracting exponent from input
    wire [EXPO_WIDTH-1:0] e1 = floating1_in[DATA_WIDTH-2:MENT_WIDTH];
    //Extracting mantissa from input
    wire [MENT_WIDTH-1:0] m1 = floating1_in[MENT_WIDTH-1:0];

    //Extracting sign from input
    wire s2 = floating2_in[DATA_WIDTH-1];
    //Extracting exponent from input
    wire [EXPO_WIDTH-1:0] e2 = floating2_in[DATA_WIDTH-2:MENT_WIDTH];
    //Extracting mantissa from input
    wire [MENT_WIDTH-1:0] m2 = floating2_in[MENT_WIDTH-1:0];


    wire rounded_product_bit; //for rounding of mantissa multiplication
    wire num_normalised; //if normalised then 1 else 0 ---> used for left shifting the product if required


    //exception if any of th exponent is 255
    assign except = (&e1) | (&e2);

    //adding the eponents and subtracting the bias i.e. 127 for single precision
    wire [EXPO_WIDTH:0] exp_sum = e1 + e2 - 8'd127;
    
    //sign of the multi_out i.e. EXOR 
    wire final_sign = s1 ^ s2;

    //implicit 1 needs to be appended
    wire [MENT_WIDTH:0] m1_ext = {1'b1, m1};
    wire [MENT_WIDTH:0] m2_ext = {1'b1, m2};

    //actual multiplication of mantissas
    wire [RES_WIDTH-1:0] mantissa_product = m1_ext * m2_ext;
    wire [RES_WIDTH-1:0] normalised_mantissa_multi;
    wire [MENT_WIDTH-1:0]final_mantissa; //23 bit final mantissa

    //NORMALIZATION
    assign rounded_product_bit = |mantissa_product[MENT_WIDTH-1:0]; //last 22 bits are or'ed

    //intermediate normalization flag
    assign num_normalised = rounded_product_bit ? 1'b1 : 1'b0;
    
    // shifting the final output based on the normalisation flag num_normalised (if 1 keep the product as it is otherwise leeftshift by 1 bit)
    assign normalised_mantissa_multi = num_normalised ? mantissa_product : mantissa_product << 1;

    //final mantissa based on the method of rounding given according to the IEEE 754 format
    assign final_mantissa = normalised_mantissa_multi[46:24] + (normalised_mantissa_multi[23]  &  rounded_product_bit);

    //handling the underflow/overflow
    wire [EXPO_WIDTH-1:0] final_exp = (e3[8]) ? 8'd0 : e3; 

    // Assemble final multi_out
    assign multi_out = {final_sign, final_exp, final_mantissa};

endmodule
