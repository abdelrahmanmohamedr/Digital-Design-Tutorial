// SAFE (IF STA times it): soft reset generated in the SAME clock
// domain as both the Tx flop and the Rx flop (DVCon Fig. 3b/3c case).
// * The assertion of soft_rst_n is synchronous to clk.
// * RDC tools report this as a CAUTION: STA must time the path
//   soft_rst_q -> tx_q (through the reset pin) -> rx.d as setup.
module soft_reset_same_clock_safe (
    output reg rx_reg,
    input  d,
    input  clk,
    input  rst_n                     // primary async reset
);
    reg soft_rst_n;                  // e.g. SW-controlled block reset
    reg tx_q;

    always @(posedge clk or negedge rst_n)
        if (!rst_n) soft_rst_n <= 1'b0;
        else        soft_rst_n <= 1'b1;

    always @(posedge clk or negedge soft_rst_n)
        if (!soft_rst_n) tx_q <= 1'b0;
        else             tx_q <= d;

    always @(posedge clk)
        rx_reg <= tx_q;              // safe in the SAME clock domain
endmodule
