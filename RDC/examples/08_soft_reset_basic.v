// Soft reset: a REGISTER output used as the reset of other flops
// SoftReg_n (clk1 domain) is the soft reset of the Reg flop (clk2
// domain): lets you reset one subsystem without resetting the chip.
// NOTE: this exact pattern is an RDC risk when clk1 != clk2.
module soft_reset_basic (
    output reg reg_q,
    input  data1, clk1,
    input  data2, clk2,
    input  rst1_n                  // primary async reset
);
    reg SoftReg_n;
    always @(posedge clk1 or negedge rst1_n)
        if (!rst1_n) SoftReg_n <= 1'b0;
        else         SoftReg_n <= data1;

    always @(posedge clk2 or negedge SoftReg_n)   // soft reset in action
        if (!SoftReg_n) reg_q <= 1'b0;
        else            reg_q <= data2;
endmodule
