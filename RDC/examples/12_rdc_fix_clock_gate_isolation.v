// FIX 2: clock-gate isolation 
// iso_n turns OFF the Rx clock before the Tx reset asserts.
// No clk_b edge -> no setup/hold sampling -> no metastability on b_reg.
// CONSTRAINT: iso_n must fall BEFORE tx_rst_n asserts
module rdc_fix_clock_gate_isolation (
    output reg b_reg,
    input  d_a,             // Tx-domain data
    input  clk_a, clk_b,
    input  tx_rst_n,        // Tx domain async reset
    input  rst_b_n,         // Rx domain async reset
    input  iso_n            // isolation enable, active-low
);
    // Tx flop
    reg tx_q;
    always @(posedge clk_a or negedge tx_rst_n)
        if (!tx_rst_n) tx_q <= 1'b0;
        else           tx_q <= d_a;

    // glitch-free ICG (latch is transparent only while clk_b is low)
    reg icg_latch;
    always @(*)
        if (!clk_b) icg_latch <= iso_n;
    wire gated_clk_b = clk_b & icg_latch;

    always @(posedge gated_clk_b or negedge rst_b_n)
        if (!rst_b_n) b_reg <= 1'b0;
        else          b_reg <= tx_q;   // safe while iso_n = 0
endmodule
