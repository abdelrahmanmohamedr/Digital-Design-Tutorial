// UNSAFE: Tx and Rx share the SAME async reset domain (rst_n), but the
// Tx flop soft reset (soft_n) is generated in a DIFFERENT clock domain
// (DVCon India 2023, Fig. 3a pattern).
// * soft_n changes on clk edges -> asynchronous to rx_clk
// * its assertion can land inside the rx_clk setup window of tx_q
// * tx_q then changes near the rx_clk edge -> rx_reg can go metastable
//   even though both flops share the async reset rst_n!
module soft_reset_cross_clock_unsafe (
    output reg rx_reg,
    input  data1, clk,
    input  data2, rx_clk,
    input  rst_n        // shared async reset domain
);
    reg soft_n;         // soft reset generated in ANOTHER clock domain
    always @(posedge clk or negedge rst_n)
        if (!rst_n) soft_n <= 1'b0;
        else        soft_n <= data1;

    reg tx_q;           // Tx flop, reset by the soft reset
    always @(posedge rx_clk or negedge soft_n)
        if (!soft_n) tx_q <= 1'b0;
        else         tx_q <= data2;

    always @(posedge rx_clk or negedge rst_n)
        if (!rst_n) rx_reg <= 1'b0;
        else        rx_reg <= tx_q;    // <-- UNSAFE RDC (same domain!)
endmodule
