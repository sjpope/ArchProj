module mul_tb;
    reg [3:0] a, b;
    wire [7:0] product;

    mul mul_instance(.a(a), .b(b), .product(product));

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, mul_tb);  

        $display("Test Start - Multiplication");
        a = 4'b0011; b = 4'b0101;
        #10 $display("a: %b, b: %b -> product: %b", a, b, product);
        
        a = 4'b1111; b = 4'b0001;
        #10 $display("a: %b, b: %b -> product: %b", a, b, product);

        $finish;
    end
endmodule
