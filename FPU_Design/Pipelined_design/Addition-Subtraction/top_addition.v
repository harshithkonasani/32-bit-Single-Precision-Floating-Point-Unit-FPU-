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
    
    input                         clk_in,
    input                         reset_n,
    input                         fsm_enable,
    
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
    wire   [DATA_WIDTH-2      :0] floating_point1;
    wire   [DATA_WIDTH-2      :0] floating_point2;

    //WIRES_FOR_STAGE2 : ALIGNING_MENTISSA
    wire   [EXPO_WIDTH        :0] rshift_by;
    wire   [MENT_WIDTH-1      :0] smaller_operand; 

    //WIRES_FOR_STAGE3 : MENTISSA_ADDITION
    wire                          equivalent_opcode;
    wire   [MENT_WIDTH-1      :0] bigger_operand;
    wire   [MENT_WIDTH        :0] rshift_operand;
    wire   [MENT_WIDTH        :0] addition_out;

    //WIRES_FOR_STAGE4 : EXPONENT_MENTISSA_NORMALIZER
    wire   [EXPO_WIDTH-1      :0] bigger_exponent;
    wire   [$clog2(MENT_WIDTH):0] normalize_position;
    wire   [MENT_WIDTH-1      :0] normalized_mentissa;
    wire   [EXPO_WIDTH-1      :0] normalized_exponent;

    //WIRES_FOR_CONTROL
    wire                          sign_out;
    wire   [MENT_WIDTH        :0] floating1_sm;
    wire   [MENT_WIDTH        :0] floating2_sm;

    //WIRES_FOR_PIPELINING_ENABLING_SIGNALS
    wire                          enable_stage1;
    wire                          enable_stage2;
    wire                          enable_stage3;
    //wire                          enable_stage4;

    assign floating_point1 = floating1_in[DATA_WIDTH-2:0];
    assign floating_point2 = floating2_in[DATA_WIDTH-2:0];
    
    assign floating1_sm    = {floating1_in[DATA_WIDTH-1],floating1_in[MENT_WIDTH-1:0]};
    assign floating2_sm    = {floating2_in[DATA_WIDTH-1],floating2_in[MENT_WIDTH-1:0]};

    //STAGE1 : EXPONENT_COMPARISION
    addition_stage1 stage1
        (
         .floating1_in        (floating_point1), // FROM_TOP
         .floating2_in        (floating_point2), // FROM_TOP
         .mux1_sel_in         (mux1_sel),        // FROM_CONTROL
         .mux2_sel_in         (mux2_sel),        // FROM_CONTROL
         .mux3_sel_in         (mux3_sel),        // FROM_CONTROL
         .exp_diff_out        (exp_diff),        // TO_CONTROL
         .bigger_operand_out  (bigger_operand),  // TO_STAGE3
         .smaller_operand_out (smaller_operand), // TO_STAGE2
         .bigger_exponent_out (bigger_exponent)  // TO_STAGE4
        );

    //PIPELINE_BETWEEN_STAGE1_AND_STAGE2
    reg [MENT_WIDTH-1      :0] smaller_operand_proc;
    reg [EXPO_WIDTH        :0] rshift_by_proc;
    always@(posedge clk_in)begin
        if(~reset_n)begin
            smaller_operand_proc <= 0;
            rshift_by_proc       <= 0;
        end else if(enable_stage1)begin
            smaller_operand_proc <= smaller_operand;
            rshift_by_proc       <= rshift_by;
        end
    end
 
    //CONTROL_UNIT_FOR_FLOATING_ADDITION
    addition_control_unit control_unit
        (
         .floating1_in          (floating1_sm),      // FROM_TOP
         .floating2_in          (floating2_sm),      // FROM_TOP
         .addition_in           (addition_out),      // FROM_STAGE3
         .opcode_in             (opcode_in),         // FROM_TOP
         .exp_diff_in           (exp_diff),          // FROM_STAGE1
         .mux1_sel_out          (mux1_sel),          // TO_STAGE1
         .mux2_sel_out          (mux2_sel),          // TO_STAGE1
         .mux3_sel_out          (mux3_sel),          // TO_STAGE1
         .sign_out              (sign_out),          // TO_TOP
         .rshift_out            (rshift_by),         // TO_STAGE2
         .equivalent_opcode_out (equivalent_opcode), // TO_STAGE3
         .normalize_position_out(normalize_position) // TO_STAGE4        
        );
    
    //STAGE2 : ALIGNING_EXPONENT
    addition_stage2 stage2 
        (
         .smaller_operand_in (smaller_operand_proc), // FROM_STAGE1
         .rshift_in          (rshift_by_proc),       // FROM_CONTROL
         .smaller_operand_out(rshift_operand)        // TO_STAGE3
        );

    //PIPELINE_BETWEEN_STAGE2_AND_STAGE3
    reg [MENT_WIDTH        :0] rshift_operand_proc; 
    reg [MENT_WIDTH-1      :0] bigger_operand_proc; 
    reg                        equivalent_opcode_proc;
    always@(posedge clk_in)begin
        if(~reset_n)begin
            rshift_operand_proc    <= 0;
            bigger_operand_proc    <= 0;
            equivalent_opcode_proc <= 0;
        end else if(enable_stage2)begin
            rshift_operand_proc    <= bigger_operand;
            bigger_operand_proc    <= rshift_operand;
            equivalent_opcode_proc <= equivalent_opcode;
        end
    end

    //STAGE3 : MENTISSA_ADDITION
    addition_stage3 stage3
        (
         .operand1_in         (bigger_operand_proc),    // FROM_STAGE1
         .operand2_in         (rshift_operand_proc),    // FROM_STAGE2
         .equivalent_opcode_in(equivalent_opcode_proc), // FROM_CONTROL
         .addition_out        (addition_out)            // TO_STAGE4,CONTROL
        );

    //PIPELINE_BETWEEN_STAGE3_AND_STAGE4
    reg [MENT_WIDTH        :0] addition_out_proc;
    reg [$clog2(MENT_WIDTH):0] normalize_position_proc;
    reg [EXPO_WIDTH-1      :0] bigger_exponent_proc;
    always@(posedge clk_in)begin
        if(~reset_n)begin
            addition_out_proc       <= 0;
            normalize_position_proc <= 0;
            bigger_exponent_proc    <= 0;
        end else if(enable_stage3)begin
            addition_out_proc       <= addition_out;
            normalize_position_proc <= normalize_position;
            bigger_exponent_proc    <= bigger_exponent;
        end
    end

    //STAGE4: EXPONENT_MENTISSA_NORMALIZER
    addition_stage4 stage4 
        (
         .addition_in            (addition_out_proc),       // FROM_STAGE3
         .normalize_position_in  (normalize_position_proc), // FROM_CONTROL
         .bigger_exponent_in     (bigger_exponent_proc),    // FROM_STAGE1
         .normalized_mentissa_out(normalized_mentissa),// TO_STAGE5
         .normalized_exponent_out(normalized_exponent) // TO_STAGE5
                             
        );

    FSM flow_control
    (
     .clk_in       (clk_in),
     .reset_n      (reset_n),
     .fsm_enable   (fsm_enable),
     .enable_stage1(enable_stage1),
     .enable_stage2(enable_stage2),
     .enable_stage3(enable_stage3)
     //.enable_stage4(enable_stage4)
    );

    //STAGE5 : ROUNDING_HARDWARE
    //YET_TO_BE_DESIGN... COMING_SOON...

    //32_BIT_FLOATING_POINT_ADDITION_SUBTRACTION_OUTPUT_IN_NORMALIZED_FORM
    assign floating_addition_out = {sign_out,normalized_exponent,normalized_mentissa};

endmodule
