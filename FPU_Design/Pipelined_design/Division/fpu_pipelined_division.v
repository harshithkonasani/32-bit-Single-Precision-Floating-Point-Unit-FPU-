`timescale 1ns / 1ps


module division_fpu #(parameter D_WIDTH = 32,
                      parameter M_WIDTH = 23,
                      parameter E_WIDTH = 8,
                      parameter M       = 48)
(
    input  [D_WIDTH-1:0] floating1_in,
    input  [D_WIDTH-1:0] floating2_in,
    input clk,
    input fsm_enable,
    input reset_n,
    output reg [D_WIDTH-1:0] floating_division_out
); 

    reg sign;
    reg [E_WIDTH - 1 : 0] exp_floating1_in, exp_floating2_in, exp_result;
    reg [M_WIDTH     : 0] mant_floating1_in, mant_floating2_in;
    reg [M_WIDTH - 1 : 0] mant_result;
    reg [M - 1 : 0] mant_temp;
    reg [D_WIDTH - 1 : 0] intermediate_result_out;
    
    
    //Proc inputs
    reg [D_WIDTH-1:0] floating_num1_proc;
    reg [D_WIDTH-1:0] floating_num2_proc;
    
    //Enable signals for each pipelined stage
    wire enable_stage1;
    wire enable_stage2;
    wire enable_stage3;
    
     FSM f(
    
        .clk_in(clk),
        .reset_n(reset_n),
        .fsm_enable(fsm_enable),
        .enable_stage1(enable_stage1),
        .enable_stage2(enable_stage2),
        .enable_stage3(enable_stage3)
        
    );
    
    //stage 1
    always@(posedge clk) 
    begin
        if(!reset_n) begin  
            floating_num1_proc <= 32'd0;
            floating_num2_proc <= 32'd0;
         end
         
         else if(enable_stage1) begin
            floating_num1_proc <= floating1_in;
            floating_num2_proc <= floating2_in;
            end
     end
    
    
    always @(*) begin
            
            exp_floating1_in = floating_num1_proc[D_WIDTH - 2 -: E_WIDTH];
            exp_floating2_in = floating_num2_proc[D_WIDTH - 2 -: E_WIDTH];
            
            mant_floating1_in = {1'b1, floating_num1_proc[M_WIDTH - 1 -: M_WIDTH]}; // Implicit leading 1
            mant_floating2_in = {1'b1, floating_num2_proc[M_WIDTH - 1 -: M_WIDTH]};

            // Subtract exponents (Bias = 127)
            exp_result = exp_floating1_in - exp_floating2_in + 8'b0111_1111;

            // Divide mantissas
            mant_temp = (mant_floating1_in << M_WIDTH) / mant_floating2_in;
            mant_result = mant_temp[M_WIDTH - 1 : 0];
               
    end
    
    //registered division exponent and mantissa
    reg [M_WIDTH - 1 : 0] mant_temp_proc;
    reg [E_WIDTH - 1 : 0] exponent_result_proc;
    
    
    //stage 2 
    always @(posedge clk) begin
        if(!reset_n) begin
            mant_temp_proc <= 32'd0;
            exponent_result_proc <= 32'd0;
        end
        else if (enable_stage2) begin
            mant_temp_proc <= mant_result;
            exponent_result_proc <= exp_result;
        end
     end
     
    
    always @(*) begin
         // Extract sign, exponent, and mantissa
            sign = floating1_in[D_WIDTH-1] ^ floating2_in[D_WIDTH-1];
            
            
            // Normalize if necessary
            if (mant_temp_proc[M_WIDTH] == 0) begin
                mant_temp_proc = mant_temp_proc << 1;
                exponent_result_proc = exponent_result_proc - 1;
            end
            
            intermediate_result_out = {sign, exponent_result_proc, mant_temp_proc[M_WIDTH - 1 : 0]};  
    end
    
    //stage 3
    always @(posedge clk) begin 
        if(!reset_n) begin
            floating_division_out <= 32'd0;
            end
        else if (enable_stage3) begin
            floating_division_out <= intermediate_result_out;
        end
   end
endmodule
