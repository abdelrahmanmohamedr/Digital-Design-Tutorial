// FIX 3: data isolation. Gate the Tx->Rx data path with an
// isolation enable so the Rx D-pin holds a stable value while the Tx
// domain resets. Same idea as UPF isolation, but sequenced by resets.
// CONSTRAINT: iso_n must assert BEFORE tx_rst_n asserts.
module rdc_fix_data_isolation (
    output reg b_reg,
    input  d_a,
    input  clk_a, clk_b,
    input  tx_rst_n, rst_b_n,
    input  iso_n        // isolation enable, active-low
);
    reg tx_q;
    always @(posedge clk_a or negedge tx_rst_n)
        if (!tx_rst_n) tx_q <= 1'b0;
        else           tx_q <= d_a;

    wire d2 = tx_q & iso_n;   // forced to 0 while isolated -> Rx D stable

    always @(posedge clk_b or negedge rst_b_n)
        if (!rst_b_n) b_reg <= 1'b0;
        else          b_reg <= d2; // safe during the Tx reset event
endmodule
