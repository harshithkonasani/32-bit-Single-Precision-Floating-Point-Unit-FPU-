module floating_point_addition#
(
    parameter integer DATA_WIDTH = 32,
    parameter integer MENT_WIDTH = 23,
    parameter integer EXPO_WIDTH = 8
)
(
    //32_BIT_FLOATING_INPUT
    input  [DATA_WIDTH-1      :0] floating1_in,
    input  [DATA_WIDTH-1      :0] floating2_in,
    
    //OPCODE_TO_DECIDE_OPERATION
    input                         opcode_in,
    //32_BIT_FLOATING_OUTPUT
    output [DATA_WIDTH-1      :0] floating_addition_out
);
    
    //WIRES_FOR_STAGE1 : EXPONENT_COMPARISION    
    wire   [EXPO_WIDTH        :0] exp_diff;
    wire                          mux1_sel;
    wire                          mux2_sel;
    wire                          mux3_sel;

    //WIRES_FOR_STAGE2 : ALIGNING_MENTISSA
    wire   [EXPO_WIDTH        :0] rshift_by;
    wire   [MENT_WIDTH-1      :0] smaller_operand; 

    //WIRES_FOR_STAGE3 : MENTISSA_ADDITION
    wire   [MENT_WIDTH-1      :0] bigger_operand;
    wire   [MENT_WIDTH        :0] rshift_operand;
    wire   [MENT_WIDTH        :0] addition_out;

    //WIRES_FOR_STAGE4 : EXPONENT_MENTISSA_NORMALIZER
    //wire                          valid_bit;
    wire   [EXPO_WIDTH-1      :0] bigger_exponent;
    wire   [$clog2(MENT_WIDTH):0] normalize_position;
    wire   [MENT_WIDTH-1      :0] normalized_mentissa;
    wire   [EXPO_WIDTH-1      :0] normalized_exponent;

    //WIRES_FOR_CONTROL
    wire                          sign_out;

    wire   [DATA_WIDTH-2      :0] float1;
    wire   [DATA_WIDTH-2      :0] float2;

    assign float1 = floating1_in[DATA_WIDTH-2:0];
    
    assign float2 = floating2_in[DATA_WIDTH-2:0];

    //STAGE1 : EXPONENT_COMPARISION
    addition_stage1 stage1
        (
         .floating1_in        (float1),    // FROM_TOP
         .floating2_in        (float2),    // FROM_TOP
         .mux1_sel_in         (mux1_sel),        // FROM_CONTROL
         .mux2_sel_in         (mux2_sel),        // FROM_CONTROL
         .mux3_sel_in         (mux3_sel),        // FROM_CONTROL
         .exp_diff_out        (exp_diff),        // TO_CONTROL
         .bigger_operand_out  (bigger_operand),  // TO_STAGE3
         .smaller_operand_out (smaller_operand), // TO_STAGE2
         .bigger_exponent_out (bigger_exponent)  // TO_STAGE4
        );
 
    //CONTROL_UNIT_FOR_FLOATING_ADDITION
    addition_control_unit control_unit
        (
         .exp_diff_in  (exp_diff),               // FROM_STAGE1
        //WARNING : CREATING_COMBINATIONAL_LOOP ???
        //          BUT RN, I THINK IT'S NOT
         .floating1_in (floating1_in),           // FROM_TOP
         .floating2_in (floating2_in),           // FROM_TOP
         .addition_in  (addition_out),           // FROM_STAGE3
         .mux1_sel_out (mux1_sel),               // TO_STAGE1
         .mux2_sel_out (mux2_sel),               // TO_STAGE1
         .mux3_sel_out (mux3_sel),               // TO_STAGE1
         .rshift_out   (rshift_by),              // TO_STAGE2
         //.valid_bit_out(valid_bit),            // TO_STAGE4
         .sign_out     (sign_out),               // TO_TOP
         .normalize_position_out                 // TO_STAGE4
                       (normalize_position)
        );
    
    //STAGE2 : ALIGNING_EXPONENT
    addition_stage2 stage2 
        (
         .smaller_operand_in  (smaller_operand), // FROM_STAGE1
         .rshift_in           (rshift_by),       // FROM_CONTROL
         .smaller_operand_out (rshift_operand)   // TO_STAGE3
        );

    //STAGE3 : MENTISSA_ADDITION
    addition_stage3 stage3
        (
         .operand1_in  (bigger_operand),         // FROM_STAGE1
         .operand2_in  (rshift_operand),         // FROM_STAGE2
         .opcode_in    (opcode_in),              // FROM_TOP
         .addition_out (addition_out)            // TO_STAGE4,CONTROL
        );

    //STAGE4: EXPONENT_MENTISSA_NORMALIZER
    addition_stage4 stage4 
        (
         .addition_in        (addition_out),     // FROM_STAGE3
         .normalize_position_in                  // FROM_CONTROL
                             (normalize_position),    
         //.valid_bit_in       (valid_bit),        // FROM_CONTROL
         .bigger_exponent_in (bigger_exponent),  // FROM_STAGE1
         .normalized_mentissa_out                // TO_STAGE5
                             (normalized_mentissa),
         .normalized_exponent_out                // TO_STAGE5
                             (normalized_exponent)
        );

    //STAGE5 : ROUNDING_HARDWARE
    //YET_TO_BE_DESIGN... COMING_SOON...

    //32_BIT_FLOATING_POINT_ADDITION_SUBTRACTION_OUTPUT_IN_NORMALIZED_FORM
    assign floating_addition_out = {sign_out,normalized_exponent,normalized_mentissa};

endmodule
