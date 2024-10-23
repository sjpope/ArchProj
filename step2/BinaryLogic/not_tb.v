module not_tb;
    reg [3:0] a;
    wire [3:0] result;

    not_test not_instance(.a(a), .result(result));

    initial begin
        a = 4'b1001;
        #10;
        $display("NOT Test: a=%b, result=%b", a, result);
        
        $finish;
    end
endmodule
