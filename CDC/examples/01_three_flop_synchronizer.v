// 3-stage synchronizer for high-frequency rx domains (Cummings Fig. 5).
// One more cycle of settle time -> MTBF goes from days to geological ages.
// Use when 2 stages cannot give enough settle window (fast clocks).
module three_flop_synchronizer #(parameter STAGES = 3) (
    output logic q,        // synchronized signal in the rx domain
    input  logic d,        // async input from the tx domain
    input  logic clk2,
    input  logic rst_n
);
    logic [STAGES-1:0] sync_ffs;
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n) sync_ffs <= '0;
        else        sync_ffs <= {sync_ffs[STAGES-2:0], d};
    assign q = sync_ffs[STAGES-1];
endmodule
