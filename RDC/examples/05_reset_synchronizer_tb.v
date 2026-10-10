// Testbench for the reset synchronizer.
// * asserts arst_n asynchronously, mid-cycle (like a board reset)
// * releases it once VERY close to a posedge on purpose (worst case)
// * watch rst_n rise exactly 2 clk edges after release, glitch-free
`timescale 1ns/1ps
module reset_synchronizer_tb;
    reg  clk = 1'b0;
    reg  arst_n = 1'b0;
    wire rst_n;

    reset_synchronizer dut (.clk(clk), .arst_n(arst_n), .rst_n(rst_n));

    always #5 clk = ~clk;                    // 100 MHz

    initial begin
        $monitor("t=%0t ns  arst_n=%b  rst_n=%b", $time, arst_n, rst_n);
        #23  arst_n = 1'b1;                  // release between edges
        #77  arst_n = 1'b0;                  // re-assert mid-cycle
        #53  arst_n = 1'b1;                  // release 2ns before posedge!
        #100 $finish;
    end
endmodule
