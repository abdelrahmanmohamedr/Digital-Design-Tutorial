// HAZARD (do not ship): the Accellera real-world RDC example in RTL.
// Q_1 (reset by async_rst_b) enables an ICG that clocks a flop reset
// by async_rst_a. If async_rst_b asserts WHILE sys_clk is high, the
// latch is transparent, EN falls mid-high-phase -> a short glitch on
// gated_clk -> a bogus edge in the OTHER reset domain.
// RULE: never let a reset from one domain gate the clock of another.
module rdc_gated_clock_glitch_bad (
    output reg dff_q,
    input  d, sys_clk,
    input  async_rst_a,       // resets the clocked flop
    input  async_rst_b        // resets the ICG enable flop - HAZARD
);
    reg q_1;
    always @(posedge sys_clk or negedge async_rst_b)
        if (!async_rst_b) q_1 <= 1'b0;
        else              q_1 <= d;

    reg icg_latch;
    always @(sys_clk or q_1)
        if (sys_clk) icg_latch <= q_1;
    wire gated_clk = sys_clk & icg_latch;   // can GLITCH on async_rst_b

    always @(posedge gated_clk or negedge async_rst_a)
        if (!async_rst_a) dff_q <= 1'b0;
        else              dff_q <= dff_q + 1'b1;  // counts the glitch!
endmodule
