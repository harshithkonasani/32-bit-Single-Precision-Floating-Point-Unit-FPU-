module addition_stage2#
(
    parameter integer MENT_WIDTH = 23,
    parameter integer EXPO_WIDTH = 8
)
(
    //INPUT_FROM_STAGE1 : EXPONENT_COMPARISION
    input  [MENT_WIDTH-1:0] smaller_operand_in, 
    //INPUT_FROM_CONTROL
    input  [EXPO_WIDTH  :0] rshift_in,    

    //OUTPUT_TO_STAGE3 : MENTISSA_ADDITION
    output [MENT_WIDTH  :0] smaller_operand_out
);

    wire   [EXPO_WIDTH-1:0] rshift;

    //IF_MSB_IS_LOGIC1_IT_IS_POSITIVE_VALUE_ELSE_IT_IS_NEGATIVE_VALUE
    assign rshift = (rshift_in[EXPO_WIDTH]) ?    rshift_in[EXPO_WIDTH-1:0]
                                            : ((~rshift_in[EXPO_WIDTH-1:0])+1'b1); 

    assign smaller_operand_out = {1'b1,smaller_operand_in} >> rshift; 

endmodule
