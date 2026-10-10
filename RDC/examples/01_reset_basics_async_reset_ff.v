// Asynchronous reset flip-flop (Cummings SNUG2002, Example 5a style)
// * Reset IS in the sensitivity list -> takes effect immediately,
//   with or without a clock
// * Reset still has priority over the clock in the if/else
module async_reset_ff (
    output reg q,
    input  d,
    input  clk,
    input  rst_n     // asynchronous, active-low
);
    // Verilog-2001 also allows: always @(posedge clk, negedge rst_n)
    always @(posedge clk or negedge rst_n)
        if (!rst_n) q <= 1'b0;
        else        q <= d;
endmodule
