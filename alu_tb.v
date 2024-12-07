// alu_tb.v
`timescale 1ns / 1ps

module alu_tb;

reg [3:0] A;
reg [3:0] B;
reg [3:0] opcode;
wire [7:0] result;
wire carry_out;
wire [3:0] remainder;

alu uut (
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result),
    .carry_out(carry_out),
    .remainder(remainder)
);

initial begin
    $dumpfile("alu_waveform.vcd");
    $dumpvars(0, alu_tb);
    
    // Initialize inputs
    A = 4'b0000;
    B = 4'b0000;
    opcode = 4'b0000;

    // Enhanced monitoring
    $monitor("\nTime: %0t | Test: %s | Opcode: %h | A: %h | B: %h | Result: %h | Carry Out: %b | Remainder: %h",
             $time, "Initialization", opcode, A, B, result, carry_out, remainder);
    
// Testing Single-Bit NOT
    $display("\n===== Testing Single-Bit NOT Operations =====");
    #10 opcode = 4'b1101; A = 4'b0001;
    #10 $display("NOT Test 1: ~1 = %b", result[0]);
    #10 opcode = 4'b1101; A = 4'b0000;
    #10 $display("NOT Test 2: ~0 = %b", result[0]);

    // Testing Single-Bit NAND
    $display("\n===== Testing Single-Bit NAND Operations =====");
    #10 opcode = 4'b1110; A = 4'b0001; B = 4'b0011;
    #10 $display("NAND Test 1: 1 NAND 3 = %b", result[0]);
    #10 opcode = 4'b1110; A = 4'b0001; B = 4'b0001;
    #10 $display("NAND Test 2: 1 NAND 1 = %b", result[0]);

    // Testing Single-Bit NOR
    $display("\n===== Testing Single-Bit NOR Operations =====");
    #10 opcode = 4'b1111; A = 4'b1010; B = 4'b1100;
    #10 $display("NOR Test 1: 10 NOR 12 = %b", result[0]);
    #10 opcode = 4'b1111; A = 4'b0000; B = 4'b0000;
    #10 $display("NOR Test 2: 0 NOR 0 = %b", result[0]);

$display("\n===== Testing 1x4-bit Shift Operations =====\n");
// Test left shift
#10 opcode = 4'b1011; A = 4'b1001; // Should shift left to 0010
#10 $display("Shift Left Test: 1001 << 1 = %b", result);
#10 opcode = 4'b1011; A = 4'b0111; // Should shift left to 1110
#10 $display("Shift Left Test: 0111 << 1 = %b", result);

// Test right shift
#10 opcode = 4'b1100; A = 4'b1001; // Should shift right to 0100
#10 $display("Shift Right Test: 1001 >> 1 = %b", result);
#10 opcode = 4'b1100; A = 4'b0110; // Should shift right to 0011
#10 $display("Shift Right Test: 0110 >> 1 = %b", result);

    // Section Header
    $display("\n===== Testing Arithmetic Operations =====\n");

    // Test Addition
    #10 opcode = 4'b0000; A = 4'b0101; B = 4'b0011; // 5 + 3 = 8
    #10 $display("Addition Test 1: 5 + 3 = %h", result);
    #10 opcode = 4'b0000; A = 4'b0110; B = 4'b0100; // 6 + 4 = 10
    #10 $display("Addition Test 2: 6 + 4 = %h", result);

    // Test Subtraction
    $display("\n===== Testing Subtraction Operations =====\n");
    #10 opcode = 4'b0001; A = 4'b0110; B = 4'b0010; // 6 - 2 = 4
    #10 $display("Subtraction Test 1: 6 - 2 = %h", result);
    #10 opcode = 4'b0001; A = 4'b1000; B = 4'b0011; // 8 - 3 = 5
    #10 $display("Subtraction Test 2: 8 - 3 = %h", result);

    // Test Multiplication
    $display("\n===== Testing Multiplication Operations =====\n");
    #10 opcode = 4'b0010; A = 4'b0011; B = 4'b0010; // 3 * 2 = 6
    #10 $display("Multiplication Test 1: 3 * 2 = %h", result);
    #10 opcode = 4'b0010; A = 4'b0100; B = 4'b0101; // 4 * 5 = 20
    #10 $display("Multiplication Test 2: 4 * 5 = %h", result);

    // Test Division
    $display("\n===== Testing Division Operations =====\n");
    #10 opcode = 4'b0011; A = 4'b1000; B = 4'b0010; // 8 / 2 = 4
    #10 $display("Division Test 1: 8 / 2 = %h", result);
    #10 opcode = 4'b0011; A = 4'b0111; B = 4'b0001; // 7 / 1 = 7
    #10 $display("Division Test 2: 7 / 1 = %h", result);

    // Section Header for Logical Operations
    $display("\n===== Testing Logical Operations =====\n");

    // Test AND
    #10 opcode = 4'b0100; A = 4'b1010; B = 4'b1100; // AND
    #10 $display("AND Test 1: 1010 AND 1100 = %h", result);
    #10 opcode = 4'b0100; A = 4'b1111; B = 4'b0000; // AND
    #10 $display("AND Test 2: 1111 AND 0000 = %h", result);

    // Test OR
    #10 opcode = 4'b0101; A = 4'b1010; B = 4'b1100; // OR
    #10 $display("OR Test 1: 1010 OR 1100 = %h", result);
    #10 opcode = 4'b0101; A = 4'b0001; B = 4'b0001; // OR
    #10 $display("OR Test 2: 0001 OR 0001 = %h", result);

    // Test NOT (B is not used)
    #10 opcode = 4'b0110; A = 4'b1010; // NOT 1010
    #10 $display("NOT Test 1: ~1010 = %h", result);
    #10 opcode = 4'b0110; A = 4'b0111; // NOT 0111
    #10 $display("NOT Test 2: ~0111 = %h", result);

    // Test XOR
    #10 opcode = 4'b0111; A = 4'b1010; B = 4'b1100; // XOR
    #10 $display("XOR Test 1: 1010 XOR 1100 = %h", result);
    #10 opcode = 4'b0111; A = 4'b1111; B = 4'b1010; // XOR
    #10 $display("XOR Test 2: 1111 XOR 1010 = %h", result);

    // Test Shift Operations
    $display("\n===== Testing Shift Operations =====\n");
    #10 opcode = 4'b1011; A = 4'b1010; B = 4'b0001; // Left Shift
    #10 $display("Shift Left Test 1: 1010 << 1 = %h", result);
    #10 opcode = 4'b1011; A = 4'b1001; B = 4'b0011; // Left Shift
    #10 $display("Shift Left Test 2: 1001 << 3 = %h", result);

    #10 opcode = 4'b1100; A = 4'b1010; B = 4'b0001; // Right Shift
    #10 $display("Shift Right Test 1: 1010 >> 1 = %h", result);
    #10 opcode = 4'b1100; A = 4'b1001; B = 4'b0011; // Right Shift
    #10 $display("Shift Right Test 2: 1001 >> 3 = %h", result);

    #10 $finish;
end

endmodule
