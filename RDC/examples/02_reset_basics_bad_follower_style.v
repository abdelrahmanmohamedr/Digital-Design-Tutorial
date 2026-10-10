// BAD: a resetable flop mixed with a follower (non-reset) flop
// inside ONE always block (Cummings SNUG2002, Example 1a).
// With a synchronous reset, rst_n becomes a data-enable for the
// second flop -> synthesizes an unnecessary loadable flop.
module bad_follower_style (
    output reg q2,
    input  d,
    input  clk,
    input  rst_n
);
    reg q1;
    always @(posedge clk)
        if (!rst_n) q1 <= 1'b0;
        else begin
            q1 <= d;
            q2 <= q1;   // follower gets a hidden load-enable!
        end
endmodule
