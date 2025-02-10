`timescale 1ns / 1ps

module tb_karatsuba_2 #(
    parameter integer DATA_WIDTH = 24  // Can be adjusted for different tests
);

    reg  [DATA_WIDTH-1:0] a_in, b_in;
    wire [(2*DATA_WIDTH)-1:0] product_out;

    // Instantiate the DUT (Device Under Test)
    karatsuba_2 #(.DATA_WIDTH(DATA_WIDTH)) DUT (
        .a_in(a_in),
        .b_in(b_in),
        .multi_out(product_out)
    );

    // Task to apply test cases
    task run_test(input [DATA_WIDTH-1:0] a, input [DATA_WIDTH-1:0] b, input [31:0] test_case_num);
    begin
        a_in = a;
        b_in = b;
        #10; // Wait for combinational logic to settle
        $display("Test Case %0d: a_in = %0d, b_in = %0d, product_out = %0d", test_case_num, a_in, b_in, product_out);
    end
    endtask

    initial begin
        $display("Starting Testbench for Karatsuba Multiplier...");

        // Basic cases
        run_test(8'b00000000, 8'b00000000, 1);
        run_test(8'b00000011, 8'b00000010, 2);
        run_test(8'b00001111, 8'b00001111, 3);
        run_test(8'b01111111, 8'b00000001, 4);

        // Edge cases
        run_test(8'b10000000, 8'b10000000, 5);
        run_test(8'b11111111, 8'b00000001, 6);
        run_test(8'b11111111, 8'b11111111, 7);

        // Random cases
        run_test(8'b10101010, 8'b01010101, 8);
        run_test(8'b01100110, 8'b00011011, 9);

        $display("Testbench Completed.");
        $finish;
    end

endmodule
