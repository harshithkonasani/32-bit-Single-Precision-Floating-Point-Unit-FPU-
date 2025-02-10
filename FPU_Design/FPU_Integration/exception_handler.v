`timescale 1ns / 1ps

module exception_handler #(parameter DATA_WIDTH = 32,
                           parameter OP_WIDTH   = 2)
(
    input  [DATA_WIDTH - 1 : 0] float_num1,
    input  [DATA_WIDTH - 1 : 0] float_num2,
    input  [OP_WIDTH   - 1 : 0] opcode,
    output reg                 sel,  // Change to reg
    output [DATA_WIDTH - 1 : 0] exception_out
);

    wire [DATA_WIDTH - 1 : 0] add_exception;
    wire [DATA_WIDTH - 1 : 0] sub_exception;
    wire [DATA_WIDTH - 1 : 0] mul_exception;
    wire [DATA_WIDTH - 1 : 0] div_exception;
    
    wire sel_add, sel_sub, sel_mul, sel_div;

    // Instantiate exception modules
    addition_exception       E1(.float_num1(float_num1), .float_num2(float_num2), .sel(sel_add), .out(add_exception));
    subtraction_exception    E2(.float_num1(float_num1), .float_num2(float_num2), .sel(sel_sub), .out(sub_exception));
    multiplication_exception E3(.float_num1(float_num1), .float_num2(float_num2), .sel(sel_mul), .out(mul_exception));
    division_exception       E4(.float_num1(float_num1), .float_num2(float_num2), .sel(sel_div), .out(div_exception));

    // Select correct sel signal based on opcode
    always @(*) begin
        case (opcode)
            2'b00: sel = sel_add;
            2'b01: sel = sel_sub;
            2'b10: sel = sel_mul;
            2'b11: sel = sel_div;
            default: sel = 1'b1;  // If invalid opcode, assume normal operation
        endcase
    end

    // Mux selects correct exception output
    mux_4x1 M1(
        .mux_add(add_exception), 
        .mux_sub(sub_exception), 
        .mux_mul(mul_exception), 
        .mux_div(div_exception), 
        .opcode(opcode), 
        .out(exception_out)
    );

endmodule
