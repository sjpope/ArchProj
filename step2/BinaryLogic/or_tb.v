module or_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    or_test or_instance(.a(a), .b(b), .result(result));

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, or_tb);

        a = 4'b1001; b = 4'b0101;
        #10;
        $display("OR Test 1: a=%b, b=%b, result=%b", a, b, result);

        a = 4'b0011; b = 4'b1100;
        #10;
        $display("OR Test 2: a=%b, b=%b, result=%b", a, b, result);

        $finish;
    end
endmodule

