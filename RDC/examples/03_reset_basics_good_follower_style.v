// GOOD: two separate always blocks -> one flop type per block
// (Cummings SNUG2002, Example 2a). The follower stays a clean flop.
module good_follower_style (
    output reg q2,
    input  d,
    input  clk,
    input  rst_n
);
    reg q1;
    always @(posedge clk)
        if (!rst_n) q1 <= 1'b0;
        else        q1 <= d;

    always @(posedge clk)
        q2 <= q1;       // follower: no reset, no enable
endmodule
