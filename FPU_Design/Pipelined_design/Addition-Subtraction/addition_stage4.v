module addition_stage4#
(
    parameter integer MENT_WIDTH = 23,
    parameter integer EXPO_WIDTH = 8 
)
(
    //INPUT_FROM_STAGE1 : EXPONENT_COMPARISION
    input  [EXPO_WIDTH-1      :0] bigger_exponent_in,

    //INPUT_FROM_STAGE3 : MENTISSA_ADDITION
    input  [MENT_WIDTH        :0] addition_in,
    
    //INPUT_FROM_CONTROL
    input  [$clog2(MENT_WIDTH):0] normalize_position_in,

    //OUTPUT_TO_STAGE5  : ROUNDING_HARDWARE
    output [MENT_WIDTH-1      :0] normalized_mentissa_out,
    output [EXPO_WIDTH-1      :0] normalized_exponent_out
);
    
    //NORMALIZATION_OF_MENTISSA
    assign normalized_mentissa_out = addition_in << normalize_position_in;

    //NORMALIZATION_OF_EXPONENT
    assign normalized_exponent_out = bigger_exponent_in - normalize_position_in;

endmodule
