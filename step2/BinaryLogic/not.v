module not_test(
    input [3:0] a,
    output [3:0] result
);
    assign result = ~a;
endmodule
