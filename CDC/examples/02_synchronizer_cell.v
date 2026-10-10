// Library-style synchronizer cell (Cummings Fig. 33 / Example 7 idea).
// Wrap your synchronizer like a hard cell so that:
//  * synthesis maps it to dedicated (fast, tau-optimized) sync flops
//  * the async clear removes X's early in gate-level simulation
//  * CDC tools recognize it as THE synchronizer for this crossing
module sync_cell #(parameter STAGES = 2) (
    output logic dest_val,        // synchronized into dest_clk
    input  logic src_val,         // async from the source domain
    input  logic dest_clk,
    input  logic dest_rst_n       // also async-clears the chain (sim X cleanup)
);
    logic [STAGES-1:0] sync_ffs;
    always_ff @(posedge dest_clk or negedge dest_rst_n)
        if (!dest_rst_n) sync_ffs <= '0;
        else             sync_ffs <= {sync_ffs[STAGES-2:0], src_val};
    assign dest_val = sync_ffs[STAGES-1];
endmodule
