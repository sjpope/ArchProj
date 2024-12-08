// alu.v
module alu (
    input [3:0] A,       // First operand
    input [3:0] B,       // Second operand
    input [3:0] opcode,  // Operation code
    output reg [7:0] result, // Result (8 bits to accommodate multiplication)
    output wire carry_out,    // Carry out for addition and subtraction, defined as wire
    output wire [3:0] remainder // Remainder for division, defined as wire
);

// Internal wires to hold outputs from different modules
wire [3:0] and_out, or_out, xor_out, nand_out, nor_out, xnor_out, not_out;
wire [4:0] add_out; // 5 bits to include carry out for adder
wire [3:0] sub_out;
wire [7:0] mul_out;
wire [3:0] div_out;
wire [3:0] shift_left_out, shift_right_out;
wire sub_borrow; // Local wire for subtraction borrow
wire [3:0] div_remainder; // Local wire for division remainder


wire not_result;
wire nand_result;
wire nor_result;
wire [3:0] shift_result;

// Step 1 - 1 Bit Gates

not_gate1b not1 (.a(A[0]), .result(not_result));
nand_gate1b nand1 (.a(A[0]), .b(B[0]), .result(nand_result));
nor_gate1b nor1 (.a(A[0]), .b(B[0]), .result(nor_result));
shifter_1b shifter1 (.a(A), .shift_control(opcode[1:0]), .result(shift_result));


// Step 2 - 4 bit ALU Functions
// Logic Operations
and_test and_inst (.a(A), .b(B), .result(and_out));
or_test or_inst (.a(A), .b(B), .result(or_out));
xor_test xor_inst (.a(A), .b(B), .result(xor_out));
nand_gate nand_inst (.a(A), .b(B), .result(nand_out));
nor_test nor_inst (.a(A), .b(B), .result(nor_out));
xnor_test xnor_inst (.a(A), .b(B), .result(xnor_out));
not_test not_inst (.a(A), .result(not_out));

// Shift Operations
shifter shift_left_inst (.a(A), .b(B), .left_shift_result(shift_left_out));  // Left Shift
shifter shift_right_inst (.a(A), .b(B), .right_shift_result(shift_right_out)); // Right Shift

// Arithmetic Operations
add add_inst (.a(A), .b(B), .cin(1'b0), .sum(add_out[3:0]), .cout(add_out[4]));
sub sub_inst (.a(A), .b(B), .diff(sub_out), .borrow(sub_borrow));
mul mul_inst (.a(A), .b(B), .product(mul_out));
div div_inst (.a(A), .b(B), .quotient(div_out), .remainder(div_remainder));

// Control Logic
always @(*) begin
    case (opcode)

        4'b1101: result = {7'b0, not_result};  // NOT operation (single-bit)
        4'b1110: result = {7'b0, nand_result}; // NAND operation (single-bit)
        4'b1111: result = {7'b0, nor_result};  // NOR operation (single-bit)
        4'b1011: result = {4'b0000, shift_result}; // Left shift
        4'b1100: result = {4'b0000, shift_result}; // Right shift

        
        4'b0000: begin // Addition
            result = {3'b000, add_out[3:0]};
            // carry_out is managed outside of always as it's now a wire
        end
        4'b0001: begin // Subtraction
            result = {4'b0000, sub_out};
            // carry_out (sub_borrow) is managed outside of always as it's now a wire
        end
        4'b0010: result = mul_out; // Multiplication
        4'b0011: begin // Division
            result = {4'b0000, div_out};
            // remainder is managed outside of always as it's now a wire
        end
        4'b0100: result = {4'b0000, and_out}; // AND
        4'b0101: result = {4'b0000, or_out};  // OR
        4'b0110: result = {4'b0000, not_out}; // NOT
        4'b0111: result = {4'b0000, xor_out}; // XOR
        4'b1000: result = {4'b0000, nand_out}; // NAND
        4'b1001: result = {4'b0000, nor_out};  // NOR
        4'b1010: result = {4'b0000, xnor_out}; // XNOR
        4'b1011: result = {4'b0000, shift_left_out};  // Left Shift
        4'b1100: result = {4'b0000, shift_right_out}; // Right Shift
        default: result = 8'b00000000; // Default case
    endcase
end

// Direct wire assignments
assign carry_out = sub_borrow;
assign remainder = div_remainder;

endmodule
