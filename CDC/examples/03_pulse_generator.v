// Pulse generator: a 1-cycle pulse on EVERY toggle of d (0->1 AND 1->0).
// XOR of the input with its registered previous value.
// Feed it the synchronized level of a TOGGLING tx signal and you get
// exactly one clean rx event per toggle - fixes data duplication.
module pulse_generator (
    output logic pulse,   // 1-cycle pulse per toggle of d
    output logic q,       // registered copy of d (for chaining)
    input  logic d,
    input  logic clk,     // rx-domain clock
    input  logic rst_n
);
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) q <= '0;
        else        q <= d;
    assign pulse = q ^ d;
endmodule
