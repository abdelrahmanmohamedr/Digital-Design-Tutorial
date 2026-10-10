// VIOLATION vs FIX: combinational logic in front of a CDC synchronizer.
// The AND output glitches; every glitch is a metastability candidate
// (activity factor a > 1, MTBF drops). CDC tools flag this as critical.
module comb_fanin_bad (
    output logic q_sync,
    input  logic a, b,        // tx-domain signals
    input  logic clk2, rst_n
);
    wire comb = a & b;        // GLITCHY - must not feed a synchronizer
    logic q1;
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n) {q_sync, q1} <= '0;
        else        {q_sync, q1} <= {q1, comb};   // <-- violation
endmodule

// GOOD: register the converged signal in the SENDING domain first;
// the FF filters the glitches, then the clean output crosses.
module comb_fanin_good (
    output logic q_sync,
    input  logic a, b,
    input  logic clk1, clk2, rst_n
);
    logic comb_q;
    always_ff @(posedge clk1 or negedge rst_n)
        if (!rst_n) comb_q <= '0;
        else        comb_q <= a & b;              // glitch filter

    logic q1;
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n) {q_sync, q1} <= '0;
        else        {q_sync, q1} <= {q1, comb_q}; // clean crossing
endmodule
