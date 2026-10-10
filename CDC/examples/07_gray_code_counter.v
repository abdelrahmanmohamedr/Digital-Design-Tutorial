// Gray-code counter, style #2 (Cummings Example 5).
// Binary register + gray register: twice the flops of style #1 but a
// much shorter combinational path -> faster clocking.
// THE GRAY OUTPUT is what crosses the CDC boundary (FIFO pointers!).
// The gray output is registered by construction - never drive a crossing
// from combinational logic.
module gray_code_counter #(parameter SIZE = 5) (
    output logic [SIZE-1:0] gray,   // registered gray count -> CDC
    input  logic            clk,    // tx-domain clock
    input  logic            inc,    // count enable
    input  logic            rst_n
);
    logic [SIZE-1:0] bin, bnext, gnext;
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) {bin, gray} <= '0;
        else        {bin, gray} <= {bnext, gnext};
    assign bnext = bin + inc;
    assign gnext = (bnext >> 1) ^ bnext;
endmodule
