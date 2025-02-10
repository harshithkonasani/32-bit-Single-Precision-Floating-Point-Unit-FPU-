`timescale 1ns / 1ps

module FSM
(
    input  clk_in,
    input  reset_n,
    input  fsm_enable,
    
    output enable_stage1,
    output enable_stage2,
    output enable_stage3
);

    parameter integer IDLE = 2'd0;
    parameter integer S1   = 2'd1;
    parameter integer S2   = 2'd2;
    parameter integer S3   = 2'd3;

    wire [1:0] fsm_state;

    reg  [1:0] fsm_state_proc;
    reg        stage1;
    reg        stage2;
    reg        stage3;

    always@(posedge clk_in)begin : FSM
        if(~reset_n)begin
            fsm_state_proc <= IDLE;
        end else if(fsm_enable)begin
            fsm_state_proc <= S1;
            case(fsm_state_proc)
                S1 : fsm_state_proc <= S2;
                S2 : fsm_state_proc <= S3;
                S3 : fsm_state_proc <= S1;
            endcase
        end else begin
            fsm_state_proc <= IDLE;
        end
    end

    assign fsm_state = fsm_state_proc;

    always@(*)begin
        case(fsm_state)
            2'd1 : begin stage1 = 1; stage2 = 0; stage3 = 0; end
            2'd2 : begin stage1 = 0; stage2 = 1; stage3 = 0; end
            2'd3 : begin stage1 = 0; stage2 = 0; stage3 = 1; end
        endcase
    end
    
    assign enable_stage1 = stage1;
    assign enable_stage2 = stage2;
    assign enable_stage3 = stage3;
    
endmodule
