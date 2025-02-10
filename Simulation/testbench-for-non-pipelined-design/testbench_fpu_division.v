`timescale 1ns / 1ps

module tb_fpu_division;
    reg [31:0] floating1_in, floating2_in;
    wire [31:0] floating_division_out;
    
    division_fpu uut (
        .floating1_in(floating1_in),
        .floating2_in(floating2_in),
        .floating_division_out(floating_division_out)
    );
    
    initial begin
        $monitor("Time=%0t floating1_in=%b floating2_in=%b floating_division_out=%b", $time, floating1_in, floating2_in, floating_division_out);
        
        // Test cases
        floating1_in = 32'h40400000; // 3.0
        floating2_in = 32'h40000000;  // 2.0
        #10;
        
        floating1_in = 32'hC0800000; // -4.0
        floating2_in = 32'h40800000;  // 4.0
        #10;
        
        floating1_in = 32'h00000000; // 0.0
        floating2_in = 32'h3F800000;  // 1.0
        #10;
        
        floating1_in = 32'h3F800000; // 1.0
        floating2_in = 32'h00000000;  // 0.0 
        #10;
        
        floating1_in = 32'b01000001000000000000000000000000; // 8.0
        floating2_in = 32'b01000000000000000000000000000000; // 2.0
        #10;

//      10.5 / 2.5 = 4.2
        floating1_in = 32'b01000001001010000000000000000000; // 10.5
        floating2_in = 32'b01000000001000000000000000000000; // 2.5
        #10;

//     -31.5 / 3.5 = -9
        floating1_in = 32'b11000001111111000000000000000000; // -31.5
        floating2_in = 32'b01000000011000000000000000000000; // 3.5
        #10;
        
        
    floating1_in = 32'b01000000010010001111010111000011; // 3.14 
    floating2_in = 32'b01000000001010011110010011110111; // 2.6546
    #10;  
     

     floating1_in = 32'b01000001010010001111010111000011; // 12.56
     floating2_in = 32'b00111111100000000000000000000000; // 1
     #10;

        
        $finish;
    end
endmodule
