module mux_4x1 (
  input      [31:0] mux_add,
  input      [31:0] mux_sub,
  input      [31:0] mux_mul,
  input      [31:0] mux_div,
  input      [2 :0] opcode,
  output reg [31:0] out
);

  always @ (*)
    begin
      case(opcode)
            2'b00 : out = mux_add;
            2'b01 : out = mux_sub;
            2'b10 : out = mux_mul;
            2'b11 : out = mux_div;
      endcase
    end
endmodule
