// FIX 1: reset sequencing
// The Rx (b) domain reset is generated from the Tx (a) domain master reset:
//   assert : arst_n asserts -> a_rst_n AND b_rst_n assert together,
//            so Rx is in reset no later than Tx -> nothing to violate
//   release: b_rst_n is released only AFTER a_rst_n (ordered startup)
module rdc_fix_reset_sequencing (
    output a_rst_n, b_rst_n,
    input  clk_a, clk_b,
    input  arst_n       // primary async reset
);
    // a-domain reset synchronizer: released by clk_a
    reg arff1, arff2;
    always @(posedge clk_a or negedge arst_n)
        if (!arst_n) {arff2, arff1} <= 2'b00;
        else         {arff2, arff1} <= {arff1, 1'b1};
    assign a_rst_n = arff2;

    // b-domain synchronizer ASYNC INPUT comes from the a-domain master
    // reset -> sequenced removal, and the b domain is never out of
    // reset while the a domain resets (Rx-side safe).
    reg brff1, brff2;
    always @(posedge clk_b or negedge a_rst_n)
        if (!a_rst_n) {brff2, brff1} <= 2'b00;
        else          {brff2, brff1} <= {brff1, 1'b1};
    assign b_rst_n = brff2;
endmodule
