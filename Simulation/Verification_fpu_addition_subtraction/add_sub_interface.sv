interface add_sub_interface#
(
    parameter integer DATA_WIDTH = 32
);
    logic [DATA_WIDTH-1:0] floating1_in;
    logic [DATA_WIDTH-1:0] floating2_in;
    logic                  opcode_in;

    logic [DATA_WIDTH-1:0] floating_addition_out;

    initial begin
        $monitor("time = %0t :: opcode_in = %0b :: floating1_in = %0b :: floating2_in = %0b :: floating_addition_out = %0b",
                 $time,         opcode_in,         floating1_in,         floating2_in,         floating_addition_out);    
    end
    
endinterface : add_sub_interface
