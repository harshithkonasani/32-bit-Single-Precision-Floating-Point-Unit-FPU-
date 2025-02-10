module addition_control_unit#
(
    parameter integer DATA_WIDTH = 32,
    parameter integer MENT_WIDTH = 23,
    parameter integer EXPO_WIDTH = 8
)
(
    //INPUT_FROM_STAGE1 : EXPONENT_COMPARISION
    input  [EXPO_WIDTH        :0] exp_diff_in,
    //INPUT_FROM_STAGE3 : MENTISSA_ADDITION
    input  [MENT_WIDTH        :0] addition_in, 
    //INPUT_FROM_TOP
    input  [MENT_WIDTH        :0] floating1_in,
    input  [MENT_WIDTH        :0] floating2_in,
    input                         opcode_in,
    //OUTPUT_TO_STAGE1  : EXPONENT_COMPARISION
    output                        mux1_sel_out,
    output                        mux2_sel_out,
    output                        mux3_sel_out,

    //OUTPUT_TO_TOP   
    output                        sign_out,

    //OUTPUT_TO_STAGE2  : ALIGNING_MENISSA
    output [EXPO_WIDTH        :0] rshift_out,

    //OUTPUT_TO_STAGE3  : MENTISSA_ADDITION
    output                        equivalent_opcode_out,

    //OUTPUT_TO_STAGE4  : EXPONENT_MENTISSA_NORMALIZER
    output [$clog2(MENT_WIDTH):0] normalize_position_out
);

    //WIRES_FOR_BIT_SWIZZLING_FLOATING_NUMBERS
    wire                          sign1    ,sign2;    
    wire   [MENT_WIDTH-1      :0] mentissa1,mentissa2;
    wire                          equivalent_opcode;
    
    //BIT_SWIZZLING
    assign sign1     = floating1_in[  MENT_WIDTH  ];
    assign sign2     = floating2_in[  MENT_WIDTH  ];

    assign mentissa1 = floating1_in[MENT_WIDTH-1:0];
    assign mentissa2 = floating2_in[MENT_WIDTH-1:0];

    //TO_GET_POSITION_OF_1ST_LOGIC1_CHECKING_FROM_MSB
    reg    [$clog2(MENT_WIDTH):0] position;

    // IF_MSB_OF [ exp_diff ] IS_LOGIC1_THEN_ASSUMPTION_IS_FALSE
    // SO_MSB_IS_LOGIC1_THEN_ALL_SELECT_LINES_SHOULD_BE_ZERO
    
    //WHAT_IF_BOTH_EXPO_ARE_EQUAL??
    assign mux1_sel_out = (exp_diff_in[EXPO_WIDTH] ? 1'b0 : 1'b1);
    assign mux2_sel_out = (exp_diff_in[EXPO_WIDTH] ? 1'b0 : 1'b1);
    assign mux3_sel_out = (exp_diff_in[EXPO_WIDTH] ? 1'b0 : 1'b1);

    //ONLY_MAGNITUDE_IS_REQUIRED_FOR_STAGE2
    assign rshift_out   = exp_diff_in;

    //PRIORITY_ENCODER_TO_GET_1ST_LOGIC1_WHILE_CHECKING_FROM_MSB
    always@(*)begin
        casez(addition_in)
            24'b1???_????_????_????_????_???? : position = 5'd24;
            24'b01??_????_????_????_????_???? : position = 5'd23;
            24'b001?_????_????_????_????_???? : position = 5'd22;
            24'b0001_????_????_????_????_???? : position = 5'd21;
            24'b0000_1???_????_????_????_???? : position = 5'd20;
            24'b0000_01??_????_????_????_???? : position = 5'd19;
            24'b0000_001?_????_????_????_???? : position = 5'd18;
            24'b0000_0001_????_????_????_???? : position = 5'd17;
            24'b0000_0000_1???_????_????_???? : position = 5'd16;
            24'b0000_0000_01??_????_????_???? : position = 5'd15;
            24'b0000_0000_001?_????_????_???? : position = 5'd14;
            24'b0000_0000_0001_????_????_???? : position = 5'd13;
            24'b0000_0000_0000_1???_????_???? : position = 5'd12;
            24'b0000_0000_0000_01??_????_???? : position = 5'd11;
            24'b0000_0000_0000_001?_????_???? : position = 5'd10;
            24'b0000_0000_0000_0001_????_???? : position = 5'd09;
            24'b0000_0000_0000_0000_1???_???? : position = 5'd08;
            24'b0000_0000_0000_0000_01??_???? : position = 5'd07;
            24'b0000_0000_0000_0000_001?_???? : position = 5'd06;
            24'b0000_0000_0000_0000_0001_???? : position = 5'd05;
            24'b0000_0000_0000_0000_0000_1??? : position = 5'd04;
            24'b0000_0000_0000_0000_0000_01?? : position = 5'd03;
            24'b0000_0000_0000_0000_0000_001? : position = 5'd02;
            24'b0000_0000_0000_0000_0000_0001 : position = 5'd01;
            24'b0000_0000_0000_0000_0000_0000 : position = 5'd00; //SPECIAL_CASE
            default                           : position = 5'd00;
        endcase
    end 

    assign normalize_position_out = 24 - position;

    //DECISION_BASED_ON_SIGNS_OF_TWO_NUMBERS_AND_OPCODE
    assign equivalent_opcode = opcode_in ? ~(sign1 ^ sign2)
                                         :  (sign1 ^ sign2);

    assign mentissa_compare  = (mentissa1 > mentissa2);

    //BLOCK_TO_DECIDE_SIGN_BIT_OF_RESULTANT_OUTPUT
    assign sign_out = ((mentissa_compare && equivalent_opcode) ? 
                      ((    (~opcode_in) && mentissa_compare ) ?  sign2 
                                                               : ~sign2)
                                                               :  sign1);
    
    //JUST_ASSIGNING_TO_OUTPUT_PORT
    assign equivalent_opcode_out = equivalent_opcode;

endmodule
