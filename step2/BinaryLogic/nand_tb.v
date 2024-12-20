include "nand.v";

module nand_tb;
    reg [3:0] a, b;
    wire [3:0] result;

    nand nand_instance(.a(a), .b(b), .result(result));

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, nand_tb);

        $display("\n\nTesting AND Gate:\n");
        a = 4'b1010; b = 4'b1100;
        #10;
        $display("NAND Test 1: a=%b, b=%b, result=%b", a, b, result);

        a = 4'b1111; b = 4'b0000;
        #10;
        $display("NAND Test 2: a=%b, b=%b, result=%b", a, b, result);
        $display("\n\n");

        $finish;
    end
endmodule
