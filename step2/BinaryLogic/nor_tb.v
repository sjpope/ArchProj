module nor_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    nor_test nor_instance(.a(a), .b(b), .result(result));

    initial begin
        a = 4'b0110; b = 4'b1001;
        #10;
        $display("NOR Test: a=%b, b=%b, result=%b", a, b, result);
        
        $finish;
    end
endmodule
