// Synchronous reset flip-flop (Cummings SNUG2002, Example 4a style)
// * Reset is NOT in the sensitivity list -> sampled on the clock edge only
// * Reset gets priority via the if/else order
module sync_reset_ff (
    output reg q,
    input  d,
    input  clk,
    input  rst_n     // synchronous, active-low
);
    always @(posedge clk)
        if (!rst_n) q <= 1'b0;
        else        q <= d;
endmodule
