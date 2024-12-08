// control.v
module control (
    input [3:0] opcode,
    output reg [13:0] control_signals
);


always @(*) begin
    control_signals = 14'b0;
    case (opcode)
        4'b0000: control_signals[0] = 1'b1;  // Addition
        4'b0001: control_signals[1] = 1'b1;  // Subtraction
        4'b0010: control_signals[2] = 1'b1;  // Multiplication
        4'b0011: control_signals[3] = 1'b1;  // Division
        4'b0100: control_signals[4] = 1'b1;  // AND
        4'b0101: control_signals[5] = 1'b1;  // OR
        4'b0110: control_signals[6] = 1'b1;  // NOT
        4'b0111: control_signals[7] = 1'b1;  // XOR
        4'b1000: control_signals[8] = 1'b1;  // NAND
        4'b1001: control_signals[9] = 1'b1;  // NOR
        4'b1010: control_signals[10] = 1'b1; // XNOR
        4'b1011: control_signals[11] = 1'b1; // Left Shift
        4'b1100: control_signals[12] = 1'b1; // Right Shift
        default: control_signals = 14'b0;
    endcase
end

endmodule
