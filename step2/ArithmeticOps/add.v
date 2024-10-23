module add(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    // Calculate the sum and carry
    assign {cout, sum} = a + b + cin;
endmodule
