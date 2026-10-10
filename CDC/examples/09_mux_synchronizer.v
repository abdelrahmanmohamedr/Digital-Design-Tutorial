// MUX recirculation synchronizer.
// * DATA crosses UNSYNCHRONIZED into the rx-domain mux - by design
// * a synchronized 1-bit enable opens the mux only when data is stable
// * while en=0 the capture flop recirculates its own output, so no async
//   edge ever reaches its D pin (and STA times the enable path clk2->clk2)
module mux_synchronizer #(parameter WIDTH = 8) (
    output logic [WIDTH-1:0] data_rx,
    input  logic [WIDTH-1:0] data_tx,   // MUST stay stable while en crosses
    input  logic             en_tx,     // tx-domain enable (level)
    input  logic             clk2,
    input  logic             rst_n
);
    // 2-FF synchronizer on the enable
    logic q1, en_sync;
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n) {en_sync, q1} <= '0;
        else        {en_sync, q1} <= {q1, en_tx};

    // gated capture: recirculates while en_sync is low
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n)        data_rx <= '0;
        else if (en_sync)  data_rx <= data_tx;
        // implicit else: hold (recirculate)
endmodule
