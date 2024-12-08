// alu_8bit.v
module alu_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] opcode,
    output [15:0] result,     // 16-bit result to accommodate larger operations (like 8-bit multiply)
    output carry_out,
    output [7:0] remainder    // 8-bit remainder for division if needed
);

    // Split inputs into two 4-bit chunks
    wire [3:0] A_low  = A[3:0];
    wire [3:0] A_high = A[7:4];
    wire [3:0] B_low  = B[3:0];
    wire [3:0] B_high = B[7:4];

    // Wires for intermediate results and signals
    wire [7:0]   result_low_expanded;
    wire [7:0]   result_high_expanded;
    wire [3:0]   result_low_4bit;
    wire [3:0]   result_high_4bit;
    wire         carry_out_low;
    wire [3:0]   remainder_low, remainder_high;

    // Instantiate low nibble 4-bit ALU
    alu alu_4bit_inst_low (
        .A(A_low),
        .B(B_low),
        .opcode(opcode),
        .result({4'b0000, result_low_4bit}), // 4-bit result packed into the lower bits
        .carry_out(carry_out_low),
        .remainder(remainder_low)
    );

    // Instantiate high nibble 4-bit ALU
    // For arithmetic ops (like addition), if needed, we can feed carry_out_low as carry_in.
    // Since the original ALU might not have a carry_in port, you can design a small control 
    // in the opcode selection or modify the approach to handle carry/borrow. 
    // If the original ALU doesn't support chaining directly, you can note this in the report 
    // and show a conceptual block diagram.
    alu alu_4bit_inst_high (
        .A(A_high),
        .B(B_high),
        .opcode(opcode),
        .result({4'b0000, result_high_4bit}),
        .carry_out(),
        .remainder(remainder_high)
    );

    // Combine results:
    // For logic ops, just combine the two 4-bit results into 8 bits:
    // For arithmetic that may produce wider output (like multiply), 
    // you need additional logic or a different approach to combine partial products.

    // Simplified approach:
    // Here we just concatenate the high and low results for logic operations.
    // For multiply and divide at 8 bits, you would need a more complex structure 
    // (multiple 4-bit multipliers and adders combined). In the report, 
    // present a block diagram showing how multiple 4-bit multipliers form an 8-bit multiplier 
    // and similarly for division.
    
    assign result = {result_high_4bit, result_low_4bit};
    assign carry_out = carry_out_low; // In a real design, you may combine carry from high part as well if needed
    assign remainder = {remainder_high, remainder_low};

endmodule
