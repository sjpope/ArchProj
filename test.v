module tb;
    reg a, b;
    wire y_not, y_nand, y_nor;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Instantiate the circuits
    not_gate U1(a, y_not);
    nand_gate U2(a, b, y_nand);
    nor_gate U3(a, b, y_nor);
    shift_circuit U4(data_in, 1'b1, data_out); // Shift right

    // Test cases
    initial begin
        $dumpfile("waveform.vcd"); // Specify the VCD filename
        $dumpvars(0, tb);          // Dump all variables in the testbench

        // Test NOT gate
        a = 0; #10;
        $display("NOT(%b) = %b", a, y_not);
        a = 1; #10;
        $display("NOT(%b) = %b", a, y_not);

        // Test NAND gate
        a = 1; b = 0; #10;
        $display("NAND(%b, %b) = %b", a, b, y_nand);
        a = 1; b = 1; #10;
        $display("NAND(%b, %b) = %b", a, b, y_nand);

        // Test NOR gate
        a = 0; b = 1; #10;
        $display("NOR(%b, %b) = %b", a, b, y_nor);
        a = 0; b = 0; #10;
        $display("NOR(%b, %b) = %b", a, b, y_nor);

        // Test Shift Circuit
        data_in = 4'b1010; #10;
        $display("Shift right(%b) = %b", data_in, data_out);
        data_in = 4'b0101; #10;
        $display("Shift right(%b) = %b", data_in, data_out);

        
    end

    // iverilog -o tb.vvp circuits.v test.v
    // vvp tb.vvp
    // gtkwave waveform.vcd
endmodule