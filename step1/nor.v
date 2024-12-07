module nor_gate1b(
    input a,
    input b,
    output result
);
    assign result = ~(a | b);
endmodule
