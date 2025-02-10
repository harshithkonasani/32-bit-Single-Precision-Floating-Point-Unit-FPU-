`timescale 1ns / 1ps

module tb_multiplication;

    parameter D_WIDTH = 32;
    
    reg [D_WIDTH-1:0] floating1_in, floating2_in;
    wire [D_WIDTH-1:0] floating_multiplication_out;
    wire [7:0]pos;
    
    real n1;
    real n2;
    real nout;
    
    // Instantiate the module
    multiplication uut (
        .floating1_in(floating1_in),
        .floating2_in(floating2_in),
        .floating_multiplication_out(floating_multiplication_out)
    );
    
    initial begin
        $monitor("Time = %0t | A = %b | B = %b | Output = %b", $time, floating1_in, floating2_in, floating_multiplication_out);
        
        // Test Case 1: 1.5 * 2.5 (Represented in IEEE 754 single-precision format)
        floating1_in = 32'h3FC00000; // 1.5
        floating2_in = 32'h40200000; // 2.5
        #10;
        
        // Test Case 2: -3.75 * 4.0
        floating1_in = 32'hC0700000; // -3.75
        floating2_in = 32'h40800000; // 4.0
        #10;
        
        // Test Case 3: 0.5 * -1.25
        floating1_in = 32'b00111111000000000000000000000000; // 0.5
        floating2_in = 32'b10111111101000000000000000000000; // -1.25
        #10;
        
        // Test Case 4: -6.5 * -2.0
        floating1_in = 32'hC0D00000; // -6.5
        floating2_in = 32'hC0000000; // -2.0
        #10;
        
        // Test Case 5: 10.0 * 0.1
        floating1_in = 32'h41200000; // 10.0
        floating2_in = 32'h3DCCCCCD; // 0.1
        #10;
        
        // Test Case 6: 4 * 5
        floating1_in = 32'b01000000100000000000000000000000; // 4
        floating2_in = 32'b01000000101000000000000000000000; // 5
        #10;
        
        //Test Case 7; 6 * 1
        floating1_in = 32'b01000000110000000000000000000000; // 6
        floating2_in = 32'b00111111100000000000000000000000; // 1 
        #10;
        
        //Test Case 8; 1.236 * 4.652
        floating1_in = 32'b00111111100111100011010100111111; // 1.236
        floating2_in = 32'b01000000100101001101110100101111; // 4.652
        #10;
        
        #100 $finish();
    end
    
endmodule
