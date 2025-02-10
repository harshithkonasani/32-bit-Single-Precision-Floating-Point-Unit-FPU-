module fpu_division (
    input [31:0] dividend,   // IEEE 754 Single Precision Floating Point
    input [31:0] divisor,
    output reg [31:0] quotient,
    output reg valid
);

    reg sign;
    reg [7:0] exp_dividend, exp_divisor, exp_result;
    reg [23:0] mant_dividend, mant_divisor, mant_result;
    reg [47:0] mant_temp;

    always @(*) begin
        valid = 0;
        if (divisor == 32'b0) begin
            quotient = 32'b0; // Handle divide by zero (could be Inf or NaN in full IEEE implementation)
            valid = 1;
        end else if (dividend == 32'b0) begin
            quotient = 32'b0; // 0 divided by anything is 0
            valid = 1;
        end else begin
            // Extract sign, exponent, and mantissa
            sign = dividend[31] ^ divisor[31];
            exp_dividend = dividend[30:23];
            exp_divisor = divisor[30:23];
            mant_dividend = {1'b1, dividend[22:0]}; // Implicit leading 1
            mant_divisor = {1'b1, divisor[22:0]};

            // Subtract exponents (Bias = 127)
            exp_result = exp_dividend - exp_divisor + 127;

            // Divide mantissas
            mant_temp = (mant_dividend << 23) / mant_divisor;
            mant_result = mant_temp[23:0];

            // Normalize if necessary
            if (mant_result[23] == 0) begin
                mant_result = mant_result << 1;
                exp_result = exp_result - 1;
            end

            // Assemble final result
            quotient = {sign, exp_result, mant_result[22:0]};
            valid = 1;
        end
    end
endmodule
