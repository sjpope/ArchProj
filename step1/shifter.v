module shifter_1b(
    input [3:0] a,
    input [1:0] shift_control,  // 00 - no shift, 01 - left shift, 10 - right shift
    output reg [3:0] result
);
    always @(*) begin
        case (shift_control)
            2'b01: result = a << 1;  // Left shift
            2'b10: result = a >> 1;  // Right shift
            default: result = a;     // No shift or undefined behavior
        endcase
    end
endmodule
