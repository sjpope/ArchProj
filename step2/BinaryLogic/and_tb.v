module and_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    // Instantiate the AND module
    and and_instance(.a(a), .b(b), .result(result));

    initial begin

        // Test Case 1
        a = 4'b0001; b = 4'b0101;
        #10; // wait for 10 time units
        $display("a: %b, b: %b, result: %b", a, b, result);
        
        // Test Case 2
        a = 4'b1111; b = 4'b1101;
        #10;
        $display("a: %b, b: %b, result: %b", a, b, result);
        
        $finish; 
    end
endmodule