module nand_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    nand nand_instance(.a(a), .b(b), .result(result));

    initial begin
        a = 4'b1010; b = 4'b1100;
        #10;
        $display("NAND Test: a=%b, b=%b, result=%b", a, b, result);
        
        $finish;
    end
endmodule