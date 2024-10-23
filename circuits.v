// 1-bit NOT gate
module not_gate(input a, output y);
    assign y = ~a;
endmodule

// 1-bit NAND gate
module nand_gate(input a, input b, output y);
    assign y = ~(a & b);
endmodule

// 1-bit NOR gate
module nor_gate(input a, input b, output y);
    assign y = ~(a | b);
endmodule

// 1x4-bit Shift Circuit
module shift_circuit(input [3:0] data_in, input shift_right, output [3:0] data_out);
    assign data_out = shift_right ? {1'b0, data_in[3:1]} : {data_in[2:0], 1'b0};
endmodule