`timescale 1ns / 1ps


module Floating_Point_Unit #(parameter DATA_WIDTH = 32,
                             parameter OP_WIDTH   = 2
)
(
    input  [DATA_WIDTH - 1 : 0] operand1_in,
    input  [DATA_WIDTH - 1 : 0] operand2_in, 
    input  [OP_WIDTH   - 1 : 0] opcode,
    
    output [DATA_WIDTH - 1 : 0] fpu_out
);
    
    //wire [DATA_WIDTH - 1 : 0] result;
    //wire [DATA_WIDTH - 1 : 0] intermediate_result;
    
    //Output demux
    wire  [DATA_WIDTH - 1 : 0] demux_addition1; 
    //wire  [DATA_WIDTH - 1 : 0] demux_subtraction1;
    wire  [DATA_WIDTH - 1 : 0] demux_multiplication1;
    wire  [DATA_WIDTH - 1 : 0] demux_division1;
    
    wire  [DATA_WIDTH - 1 : 0] demux_addition2; 
    //wire  [DATA_WIDTH - 1 : 0] demux_subtraction2;
    wire  [DATA_WIDTH - 1 : 0] demux_multiplication2;
    wire  [DATA_WIDTH - 1 : 0] demux_division2;
    
    // Output mux
    wire [DATA_WIDTH - 1 : 0] result_addition_out;
    wire [DATA_WIDTH - 1 : 0] result_subtraction_out;
    wire [DATA_WIDTH - 1 : 0] result_multiplication_out;
    wire [DATA_WIDTH - 1 : 0] result_division_out ;
   
    
    demux_1x4 D3 (.in(operand1_in) , .opcode(opcode), .demux_add(demux_addition1), .demux_sub(demux_addition1), .demux_mul(demux_multiplication1), .demux_div(demux_division1));
    
    demux_1x4 D4 (.in(operand2_in) , .opcode(opcode), .demux_add(demux_addition2), .demux_sub(demux_addition2), .demux_mul(demux_multiplication2), .demux_div(demux_division2));    
    
    //Module Instantiations
    floating_point_addition f1(.floating1_in(operand1_in), .floating2_in(operand2_in),.opcode_in(opcode[0]), .floating_addition_out(result_addition_out));
    
    multiplication          m1(.floating1_in(demux_multiplication1), .floating2_in(demux_multiplication2), .floating_multiplication_out(result_multiplication_out));
    
    division_fpu            d1(.floating1_in(demux_division1), .floating2_in(demux_division2), .floating_division_out(result_division_out));
    
    //Selecting One Output from the FPU
    mux_4x1                 m2(.mux_add(result_addition_out), .mux_sub(result_addition_out), .mux_mul(result_multiplication_out), .mux_div(result_division_out), .opcode(opcode), .out(fpu_out));
    
endmodule
