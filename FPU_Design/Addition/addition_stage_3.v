module addition_stage3#
(
    parameter integer MENT_WIDTH = 23
)
(
    //INPUT_FROM_STAGE1 : EXPONENT_COMPARISION
    input  [MENT_WIDTH-1:0] operand1_in,
    //INPUT_FROM_STAGE2 : ALIGNING_MENTISSA
    input  [MENT_WIDTH-1:0] operand2_in,
    //INPUT_FROM_TOP
    input                   opcode_in,

    //OUTPUT_TO_STAGE4  : EXPONENT_MENTISSA_NORMALIZER
    output [MENT_WIDTH  :0] addition_out  
);

    //TO_GET_TWO'S_COMPLIMENT_OF_OPERAND2
    wire   [MENT_WIDTH  :0] operand2_intermediate; 
    
    //RESOURCE_SHARING : USING_JUST_ONE_ADDITION_MODULE
    assign operand2_intermediate = opcode_in ? (~{1'b1,operand2_in} + 1'b1)
                                             :   {1'b1,operand2_in};

    //ACTUAL_ADDITION_OF_MENTISSAS
    assign addition_out   = {1'b1,operand1_in} + operand2_intermediate;

endmodule
