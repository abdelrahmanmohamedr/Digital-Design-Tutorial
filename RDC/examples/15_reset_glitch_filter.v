// Reset glitch filter (Cummings SNUG2002, Sec. 8 / Fig. 11 idea).
// An async reset answers ANY pulse wide enough to trip the flop, so
// board noise becomes a spurious reset. Delay the ASSERTION through a
// WIDTH-stage shift register: a glitch shorter than WIDTH clk cycles
// never reaches the downstream synchronizer.
// * needs a free-running clock (that is why Cummings calls it "ugly")
// * add a Schmitt-trigger pad on the raw reset input
// * feed rst_flt_n into a normal reset synchronizer afterwards
module reset_glitch_filter #(parameter WIDTH = 4) (
    output rst_flt_n,
    input  raw_rst_n,   // noisy async reset input
    input  clk          // free-running clock required for the filter
);
    reg [WIDTH-1:0] dly;
    initial begin
        dly = {WIDTH{1'b1}};   // FPGA sim; on ASIC the PoR covers startup
    end
    always @(posedge clk)
        dly <= {dly[WIDTH-2:0], raw_rst_n};
    // low only after raw_rst_n stayed low for WIDTH clk edges
    assign rst_flt_n = dly[WIDTH-1];
endmodule
