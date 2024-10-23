module div_tb;
    reg [3:0] a, b;
    wire [3:0] quotient, remainder;

    div div_instance(.a(a), .b(b), .quotient(quotient), .remainder(remainder));

    initial begin

        $dumpfile("div.vcd");
        $dumpvars(0, div_tb);  

        $display("Test Start - Division");
        
        a = 4'b1001; b = 4'b0010;
        #10 $display("Division Test 1: a: %b, b: %b -> quotient: %b, remainder: %b", a, b, quotient, remainder);
        
        b = 4'b0000; 
        #10 $display("Division Test 2: a: %b, b: %b -> quotient: %b, remainder: %b", a, b, quotient, remainder);

        $finish;
    end
endmodule
