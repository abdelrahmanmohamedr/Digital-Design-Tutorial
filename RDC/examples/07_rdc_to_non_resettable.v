// UNSAFE RDC to a non-resettable register (NRR).
// pipe has NO reset pin (pipeline / follower flop). When rst_a_n
// asserts, q_a changes asynchronously and pipe samples the changing
// value -> setup/hold violation on pipe -> metastability.
module rdc_to_non_resettable (
    output reg pipe,
    input  d_a,
    input  clk_a, clk_b,
    input  rst_a_n
);
    reg q_a;
    always @(posedge clk_a or negedge rst_a_n)
        if (!rst_a_n) q_a <= 1'b0;
        else          q_a <= d_a;

    always @(posedge clk_b)      // NRR: no reset
        pipe <= q_a;             // <-- RDC path, UNSAFE during assertion
endmodule
