module sub(
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output borrow
);
    // Calculate the difference and borrow
    assign {borrow, diff} = {1'b0, a} - b;
endmodule
