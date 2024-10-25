module xor_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    xor_test xor_instance(.a(a), .b(b), .result(result));

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, xor_tb);

        a = 4'b1101; b = 4'b0111;
        #10;
        $display("XOR Test 1: a=%b, b=%b, result=%b", a, b, result);

        a = 4'b1010; b = 4'b1010;
        #10;
        $display("XOR Test 2: a=%b, b=%b, result=%b", a, b, result);

        $finish;
    end
endmodule
