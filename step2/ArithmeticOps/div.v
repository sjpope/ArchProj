module div(
    input [3:0] a,
    input [3:0] b,
    output [3:0] quotient,
    output [3:0] remainder
);
    // Handle division by zero; output is undefined if b is zero
    assign quotient = (b != 0) ? a / b : 0;
    assign remainder = (b != 0) ? a % b : 0;
endmodule
