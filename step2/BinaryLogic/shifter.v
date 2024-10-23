module shifter(
    input [3:0] a,
    input [3:0] b,  // num of shift positions
    output [3:0] left_shift_result,
    output [3:0] right_shift_result
);
    assign left_shift_result = a << b;
    assign right_shift_result = a >> b;
endmodule
