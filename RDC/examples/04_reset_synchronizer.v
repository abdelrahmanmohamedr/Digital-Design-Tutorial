// Reset synchronizer: asynchronous assert, SYNCHRONOUS release
// * arst_n : raw async reset (pad / PoR)
// * rst_n  : release aligned to clk rising edges -> meets recovery time
module reset_synchronizer (
    output reg rst_n,
    input  clk,
    input  arst_n
);
    reg rff1;
    always @(posedge clk or negedge arst_n)
        if (!arst_n) {rst_n, rff1} <= 2'b00;
        else         {rst_n, rff1} <= {rff1, 1'b1};
endmodule
