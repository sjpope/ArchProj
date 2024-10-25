module xnor_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    xnor_test xnor_instance(.a(a), .b(b), .result(result));

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, xnor_tb);          
        $display("\n\nTesting AND Gate:\n");
        a = 4'b1010; b = 4'b1010;
        #10;
        $display("XNOR Test 1: a=%b, b=%b, result=%b", a, b, result);

        a = 4'b0111; b = 4'b1001;
        #10;
        $display("XNOR Test 2: a=%b, b=%b, result=%b", a, b, result);
        
        $finish;
    end
endmodule