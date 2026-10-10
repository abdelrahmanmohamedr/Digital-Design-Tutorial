// UNSAFE RDC: Tx flop reset by rst_a_n, Rx flop reset by rst_b_n.
// rst_a_n can assert close to a clk_b rising edge -> q_a changes
// inside the Rx setup/hold window -> b_reg goes metastable.
module rdc_unsafe_crossing (
    output reg b_reg,
    input  d_a,
    input  clk_a, clk_b,
    input  rst_a_n, rst_b_n      // two independent async resets
);
    reg q_a;
    always @(posedge clk_a or negedge rst_a_n)
        if (!rst_a_n) q_a <= 1'b0;
        else          q_a <= d_a;

    always @(posedge clk_b or negedge rst_b_n)
        if (!rst_b_n) b_reg <= 1'b0;
        else          b_reg <= q_a;  // <-- RDC path, UNSAFE
endmodule
