module xnor_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    xnor_test xnor_instance(.a(a), .b(b), .result(result));

    initial begin
        a = 4'b1010; b = 4'b1010;
        #10;
        $display("XNOR Test: a=%b, b=%b, result=%b", a, b, result);
        
        $finish;
    end
endmodule
