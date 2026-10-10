// 2-flop synchronizer: the basic CDC building block.
// * FF1 takes the metastability hit, FF2 gives it one rx_clk cycle to settle
// * Rules: no logic between the flops, no fanout from FF1,
//   ONE instance per signal (never two syncs for the same crossing)
module two_flop_synchronizer (
    output logic q,        // clean, synchronized signal in the rx domain
    input  logic d,        // async input - register it in the tx domain first!
    input  logic clk2,     // receiving (destination) clock
    input  logic rst_n
);
    logic q1;
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n) {q, q1} <= '0;
        else        {q, q1} <= {q1, d};
endmodule
