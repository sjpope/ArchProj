module add_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire cout;

    add add_instance(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $dumpfile("add.vcd");
        $dumpvars(0, add_tb);  

        $display("Test Start - Addition");
        a = 4'b0110; b = 4'b0011; cin = 0;
        #10 $display("Addition Test 1: a: %b, b: %b, cin: %b -> sum: %b, cout: %b", a, b, cin, sum, cout);
        
        a = 4'b1111; b = 4'b0001; cin = 1;
        #10 $display("Addition Test 2: a: %b, b: %b, cin: %b -> sum: %b, cout: %b", a, b, cin, sum, cout);

        $finish;
    end
endmodule
