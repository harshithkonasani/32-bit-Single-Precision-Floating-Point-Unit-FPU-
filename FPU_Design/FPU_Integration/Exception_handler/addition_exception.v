`timescale 1ns / 1ps

module addition_exception#(parameter DATA_WIDTH = 32
                 
                           )
(
    input  [DATA_WIDTH - 1 : 0] float_num1,
    input  [DATA_WIDTH - 1 : 0] float_num2,
    output reg                      sel,
    output reg [DATA_WIDTH - 1 : 0] out
    );
    
    always @(*)
    begin
        if(float_num1 == 32'h7F80_0000 || float_num2 == 32'h7F80_0000) begin   
            out = 32'h7F80_0000;
            sel = 1'b0;
        end
        else begin
            out = 32'h1430_0000;
            sel = 1'b1;
        end
    end
endmodule
