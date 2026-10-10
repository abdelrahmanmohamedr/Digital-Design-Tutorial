// Asynchronous FIFO with gray-coded pointers.
// * pointer width = AW+1: the extra MSB is the wrap flag (power-of-2 depth)
// * pointers go binary->gray, are REGISTERED, then 2-FF synchronized into
//   the other domain and converted back to binary there
// * full  computed in the WRITE domain from the synced read pointer
// * empty computed in the READ domain from the synced write pointer
// * both flags are pessimistic (pointer arrives late) -> safe by design
// * first-word-fall-through read: rdata always shows mem[rptr]
// NOTE: DEPTH must be a power of 2 and at least 4 (full-flag bit slice).
module async_fifo #(parameter DEPTH = 16, WIDTH = 8) (
    // write domain
    input  logic             wclk, wrst_n,
    input  logic             winc,
    input  logic [WIDTH-1:0] wdata,
    output logic             wfull,
    // read domain
    input  logic             rclk, rrst_n,
    input  logic             rinc,
    output logic [WIDTH-1:0] rdata,
    output logic             rempty
);
    localparam AW = $clog2(DEPTH);

    logic [AW:0] wbin, wgray, rbin, rgray;
    logic [AW:0] wbin_next, wgray_next, rbin_next, rgray_next;
    logic w_en, r_en;

    assign w_en = winc & ~wfull;
    assign r_en = rinc & ~rempty;

    // ---- pointers ----
    always_ff @(posedge wclk or negedge wrst_n)
        if (!wrst_n) {wbin, wgray} <= '0;
        else         {wbin, wgray} <= {wbin_next, wgray_next};
    assign wbin_next  = wbin + (w_en ? 1 : 0);
    assign wgray_next = (wbin_next >> 1) ^ wbin_next;

    always_ff @(posedge rclk or negedge rrst_n)
        if (!rrst_n) {rbin, rgray} <= '0;
        else         {rbin, rgray} <= {rbin_next, rgray_next};
    assign rbin_next  = rbin + (r_en ? 1 : 0);
    assign rgray_next = (rbin_next >> 1) ^ rbin_next;

    // ---- wgray -> read domain (2-FF sync + gray2bin) ----
    logic [AW:0] wg_r1, wg_r2, wbin_r;
    always_ff @(posedge rclk or negedge rrst_n)
        if (!rrst_n) {wg_r2, wg_r1} <= '0;
        else         {wg_r2, wg_r1} <= {wg_r1, wgray};
    always_comb begin
        for (int i = 0; i <= AW; i++)
            wbin_r[i] = ^(wg_r2 >> i);
    end

    // ---- rgray -> write domain (2-FF sync + gray2bin) ----
    logic [AW:0] rg_w1, rg_w2, rbin_w;
    always_ff @(posedge wclk or negedge wrst_n)
        if (!wrst_n) {rg_w2, rg_w1} <= '0;
        else         {rg_w2, rg_w1} <= {rg_w1, rgray};
    always_comb begin
        for (int i = 0; i <= AW; i++)
            rbin_w[i] = ^(rg_w2 >> i);
    end

    // ---- flags (registered, pessimistic) ----
    // empty: next read gray equals the SYNCED write gray
    always_ff @(posedge rclk or negedge rrst_n)
        if (!rrst_n) rempty <= '1;
        else         rempty <= (rgray_next == wg_r2);
    // full: next write gray equals synced read gray with the top 2 bits flipped
    always_ff @(posedge wclk or negedge wrst_n)
        if (!wrst_n) wfull <= '0;
        else         wfull <= (wgray_next ==
                           {~rg_w2[AW], ~rg_w2[AW-1], rg_w2[AW-2:0]});

    // ---- memory: write on wclk, FWFT read ----
    logic [WIDTH-1:0] mem [0:DEPTH-1];
    always_ff @(posedge wclk)
        if (w_en) mem[wbin[AW-1:0]] <= wdata;
    assign rdata = mem[rbin[AW-1:0]];
endmodule
