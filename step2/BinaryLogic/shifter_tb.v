module shifter_tb;
    reg [3:0] a, b;
    wire [3:0] left_shift_result, right_shift_result;

    shifter shifter_instance(.a(a), .b(b), .left_shift_result(left_shift_result), .right_shift_result(right_shift_result));

    initial begin
        $dumpfile("shifter.vcd");
        $dumpvars(0, shifter_tb);

        a = 4'b1101; b = 4'b0010; // Shift by 2 bits
        #10;
        $display("Shifter Test 1: a=%b, b=%b, left_shift=%b, right_shift=%b", a, b, left_shift_result, right_shift_result);

        a = 4'b1001; b = 4'b0001; // Shift by 1 bit
        #10;
        $display("Shifter Test 2: a=%b, b=%b, left_shift=%b, right_shift=%b", a, b, left_shift_result, right_shift_result);

        $finish;
    end
endmodule

