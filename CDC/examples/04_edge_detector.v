// Edge detectors: 1-cycle pulse on ONE edge direction only.
// * rising  : pulse =  d & ~q
// * falling : pulse = ~d &  q
// Active-low output variants: NOR the pair instead of AND.
module edge_detector_rising (
    output logic pulse,   // 1-cycle pulse on every 0 -> 1 of d
    output logic q,
    input  logic d,
    input  logic clk,
    input  logic rst_n
);
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) q <= '0;
        else        q <= d;
    assign pulse = d & ~q;
endmodule

module edge_detector_falling (
    output logic pulse,   // 1-cycle pulse on every 1 -> 0 of d
    output logic q,
    input  logic d,
    input  logic clk,
    input  logic rst_n
);
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) q <= '0;
        else        q <= d;
    assign pulse = ~d & q;
endmodule
