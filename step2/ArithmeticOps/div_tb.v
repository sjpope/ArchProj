module div_tb;
    reg [3:0] a, b;
    wire [3:0] quotient, remainder;

    // Instantiate the Division module
    div div_instance(.a(a), .b(b), .quotient(quotient), .remainder(remainder));

    initial begin
        $display("Test Start - Division");
        a = 4'b1001; b = 4'b0010;
        #10 $display("a: %b, b: %b -> quotient: %b, remainder: %b", a, b, quotient, remainder);
        
        b = 4'b0000; // Test division by zero
        #10 $display("a: %b, b: %b -> quotient: %b, remainder: %b", a, b, quotient, remainder);

        $finish;
    end
endmodule
