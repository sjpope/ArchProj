module not_tb;
    reg [3:0] a;
    wire [3:0] result;

    not_test not_instance(.a(a), .result(result));

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, not_tb);

        a = 4'b1001;
        #10;
        $display("NOT Test 1: a=%b, result=%b", a, result);

        a = 4'b0110;
        #10;
        $display("NOT Test 2: a=%b, result=%b", a, result);

        $finish;
    end
endmodule
