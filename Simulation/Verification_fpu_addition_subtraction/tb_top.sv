import uvm_pkg::*;
`include "uvm_macros.svh"
`include "add_sub_interface.sv"

module tb_top();

    reg [DATA_WIDTH-1:0] floating1_in;
    reg [DATA_WIDTH-1:0] floating2_in;
    reg                  opcode_in;

    wire [DATA_WIDTH-1:0] floating_addition_out;

    floating_point_addition#
    (
        .DATA_WIDTH(32),
        .MENT_WIDTH(23),
        .EXPO_WIDTH(8)
    )DUT
    (
        .floating1_in         (floating1_in),
        .floating2_in         (floating2_in),
        .opcode_in            (opcode_in),
        .floating_addition_out(floating_addition_out)
    );

    add_sub_interface#(.DATA_WIDTH(32)) vif();
    
    initial begin
        run_test("add_sub_test");
    end


endmodule
