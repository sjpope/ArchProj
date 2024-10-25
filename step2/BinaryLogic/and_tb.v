`include "and.v"

module and_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    and_test and_instance(
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, and_tb); 

        $display("\n\n Testing AND Gate:\n");

        $monitor("%g ns | A = %b | B = %b | result = %b", $time, a, b, result);

        a = 4'b0001; b = 4'b0101;
        #10; 
        $display("AND Test 1: a: %b, b: %b, result: %b", a, b, result);
        
        a = 4'b1111; b = 4'b1101;
        #10;
        $display("AND Test 2: a: %b, b: %b, result: %b", a, b, result);

        $finish; 
    end
endmodule
