module sub_tb;
    reg [3:0] a, b;
    wire [3:0] diff;
    wire borrow;

    sub sub_instance(.a(a), .b(b), .diff(diff), .borrow(borrow));

    initial begin
        $dumpfile("sub.vcd");
        $dumpvars(0, sub_tb);  

        $display("Test Start - Subtraction");
        a = 4'b0110; b = 4'b0011;
        #10 $display("a: %b, b: %b -> diff: %b, borrow: %b", a, b, diff, borrow);
        
        a = 4'b0010; b = 4'b0111;
        #10 $display("a: %b, b: %b -> diff: %b, borrow: %b", a, b, diff, borrow);

        $finish;
    end
endmodule
