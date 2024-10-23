module or_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    or_test or_instance(.a(a), .b(b), .result(result));

    initial begin
        a = 4'b1001; b = 4'b0101;
        #10;
        $display("OR Test: a=%b, b=%b, result=%b", a, b, result);
        
        $finish;
    end
endmodule
