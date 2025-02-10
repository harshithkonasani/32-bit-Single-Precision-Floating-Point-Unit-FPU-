`timescale 1ns / 1ps

module division_fpu #(parameter D_WIDTH = 32,
                      parameter M_WIDTH = 23,
                      parameter E_WIDTH = 8,
                      parameter M       = 48)
(
    input  [D_WIDTH-1:0] floating1_in,
    input  [D_WIDTH-1:0] floating2_in,
    output [D_WIDTH-1:0] floating_division_out
); 

    reg sign;
    reg [E_WIDTH - 1 : 0] exp_floating1_in, exp_floating2_in, exp_result;
    reg [M_WIDTH     : 0] mant_floating1_in, mant_floating2_in;
    reg [M_WIDTH - 1 : 0] mant_result;
    reg [M - 1 : 0] mant_temp;
    reg [D_WIDTH - 1 : 0] intermediate_result_out;
    
    always @(*) begin
    
            // Extract sign, exponent, and mantissa
            sign = floating1_in[D_WIDTH-1] ^ floating2_in[D_WIDTH-1];
            
            exp_floating1_in = floating1_in[D_WIDTH - 2 -: E_WIDTH];
            exp_floating2_in = floating2_in[D_WIDTH - 2 -: E_WIDTH];
            
            mant_floating1_in = {1'b1, floating1_in[M_WIDTH - 1 -: M_WIDTH]}; // Implicit leading 1
            mant_floating2_in = {1'b1, floating2_in[M_WIDTH - 1 -: M_WIDTH]};

            // Subtract exponents (Bias = 127)
            exp_result = exp_floating1_in - exp_floating2_in + 8'b0111_1111;

            // Divide mantissas
            mant_temp = (mant_floating1_in << M_WIDTH) / mant_floating2_in;
            mant_result = mant_temp[M_WIDTH - 1 : 0];

            // Normalize if necessary
            if (mant_result[M_WIDTH] == 0) begin
                mant_result = mant_result << 1;
                exp_result = exp_result - 1;
            end
            
           intermediate_result_out = {sign, exp_result, mant_result[M_WIDTH - 1 : 0]};     
    end
    
    assign floating_division_out = intermediate_result_out; //Assigning the final result out
    
endmodule
