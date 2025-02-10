`timescale 1ns / 1ps

module fpu_tb();

    parameter DATA_WIDTH = 32;
    parameter OP_WIDTH   = 2;
    
    reg [DATA_WIDTH - 1 : 0] operand1_in;
    reg [DATA_WIDTH - 1 : 0] operand2_in; 
    reg [OP_WIDTH   - 1 : 0] opcode;
    
    wire [DATA_WIDTH - 1 : 0] final_result;
    
    Top_Module#(.DATA_WIDTH(DATA_WIDTH), .OP_WIDTH(OP_WIDTH)) dut(
        .operand1_in(operand1_in), .operand2_in(operand2_in),
        .opcode(opcode), .final_result(final_result)
    );
    
    initial begin
        $monitor("Time = %0t, Opcode = %0b, Operand1 = %h, Operand2 = %h, Result = %h", 
                 $time, opcode, operand1_in, operand2_in, final_result);

        // Test cases
        //ADDITION
        #10 opcode = 2'b00; operand1_in = 32'h40400000; operand2_in = 32'h40800000; // 3.0 + 4.0 = 7.0
        #10 opcode = 2'b00; operand1_in = 32'h437dbd71; operand2_in = 32'h4426be14; // 253.74 + 666.97 = 
        #10 opcode = 2'b00; operand1_in = 32'h445d8000; operand2_in = 32'h44300000; // 886 + 704  = 
        #10 opcode = 2'b00; operand1_in = 32'h4299e148; operand2_in = 32'h433a6e14; // 76.94 + 186.43 = 
        #10 opcode = 2'b00; operand1_in = 32'hc3620000; operand2_in = 32'h43240000; // -226 + 164 = 
        #10 opcode = 2'b00; operand1_in = 32'hc2f951ec; operand2_in = 32'h42ace148; // -124.66 + 86.44 = 
        #10 opcode = 2'b00; operand1_in = 32'h44800000; operand2_in = 32'h448a4000; // 1024 + 1106 = 
        #10 opcode = 2'b00; operand1_in = 32'h461c3000; operand2_in = 32'h46145800; //  9996 + 9494 =
        #10 opcode = 2'b00; operand1_in = 32'hc60ad95e; operand2_in = 32'h45a9e5db; // -8886.342 + 5436.732 = 
        #10 opcode = 2'b00; operand1_in = 32'h4750f803; operand2_in = 32'h47767bea; // 53,496.012 + 63,099.914 = 

        //SUBTRACTION
        #10 opcode = 2'b01; operand1_in = 32'h42f23df4; operand2_in = 32'h4281820c; // 127.121 - 64.754 = 63.0
        #10 opcode = 2'b01; operand1_in = 32'h44790000; operand2_in = 32'h44414000; // 996 - 773 = 6.0
        #10 opcode = 2'b01; operand1_in = 32'h43800f7d; operand2_in = 32'h43474312; // 256.121 - 199.262 = 56.85901
        #10 opcode = 2'b01; operand1_in = 32'hc2ea0000; operand2_in = 32'h44260000; // -117 - 664 = 
        #10 opcode = 2'b01; operand1_in = 32'h4457cb23; operand2_in = 32'h42e13333; // 863.174 - 112.6 = 
        #10 opcode = 2'b01; operand1_in = 32'h4795f800; operand2_in = 32'h475e3b00; // 76784 - 56891 = 
        #10 opcode = 2'b01; operand1_in = 32'hc65ca400; operand2_in = 32'hc5d11800; // -14121 - (-6691) = 
        #10 opcode = 2'b01; operand1_in = 32'hc4922852; operand2_in = 32'hc2e45c29; //  -1169.26 - (-114.18) = 
        #10 opcode = 2'b01; operand1_in = 32'h43801646; operand2_in = 32'hc2b20000; // 256.174 - (-89) = 
        #10 opcode = 2'b01; operand1_in = 32'h47c13100; operand2_in = 32'h47ae6480; // 98914 - 89289 = 
    
        //MULTIPLICATION
        #10 opcode = 2'b10; operand1_in = 32'h41a80000; operand2_in = 32'h41a80000; // 21.0 * 21.0 = 441.0
        #10 opcode = 2'b10; operand1_in = 32'h44563127; operand2_in = 32'hc1470a3d; // 856.768 * (-12.44)
        #10 opcode = 2'b10; operand1_in = 32'h41400000; operand2_in = 32'h4197851f; // 12.0 * 18.94 = 
        #10 opcode = 2'b10; operand1_in = 32'h3a3ed741; operand2_in = 32'h3d8603d5; // 0.000728 * 0.065437 = 0.0000047638136
        #10 opcode = 2'b10; operand1_in = 32'h43df10c5; operand2_in = 32'h419a6873; // 446.131 * 19.301 = 441.0
        #10 opcode = 2'b10; operand1_in = 32'h47c0bc80; operand2_in = 32'h465fc400; // 98681 * 14321 = 
        #10 opcode = 2'b10; operand1_in = 32'h42c1fcee; operand2_in = 32'hc33a3d71; // 96.994 * (-186.24) = 
        #10 opcode = 2'b10; operand1_in = 32'h3f79f55a; operand2_in = 32'h41200000; // 0.9764 * 10 = 0.0000047638136
        #10 opcode = 2'b10; operand1_in = 32'h3e27ef9e; operand2_in = 32'hbe27ef9e; // 0.164 * (-0.164) = 
        #10 opcode = 2'b10; operand1_in = 32'hc3ac8000; operand2_in = 32'hc2b40000; // -345 * -(90) = 
    
        //DIVISON
        #10 opcode = 2'b11; operand1_in = 32'h43800000; operand2_in = 32'h41800000; // 256.0 / 16.0 = 16.0
        #10 opcode = 2'b11; operand1_in = 32'h445e644a; operand2_in = 32'hc1470a3d; // 889.567 / (-12.44) = -71.508
        #10 opcode = 2'b11; operand1_in = 32'h44428000; operand2_in = 32'h44428000; // 778.0 / 778.0 =
        #10 opcode = 2'b11; operand1_in = 32'hc1fcf5c3; operand2_in = 32'h410b9db2; // -31.62/8.726 =
        #10 opcode = 2'b11; operand1_in = 32'hbfad0e56; operand2_in = 32'hbf791687; //-1.352/-0.973 =
        #10 opcode = 2'b11; operand1_in = 32'h43100000; operand2_in = 32'h41300000; // 144/11 = 
        #10 opcode = 2'b11; operand1_in = 32'h44f18000; operand2_in = 32'h41d80000; // 1932/27 =
        #10 opcode = 2'b11; operand1_in = 32'h42ace148; operand2_in = 32'h408e147b; // 86.44/4.44 =
        #10 opcode = 2'b11; operand1_in = 32'h00000000; operand2_in = 32'h3d3851ec; // 0/0.045 =
        #10 opcode = 2'b11; operand1_in = 32'h45d8c0f9; operand2_in = 32'h00000000; // 6936.1214/0.001 = 

        #500 $finish;
    end
    
endmodule
