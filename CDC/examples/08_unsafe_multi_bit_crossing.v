// UNSAFE: a 2-bit FSM state crossing through TWO independent synchronizers.
// The two bits can settle one cycle apart: state 2'b11 (WRITE) can be
// received as 2'b10 (READ) for a cycle - a legal but WRONG state.
// FIXES: converge to 1 bit in the tx domain, gray-code the value,
// or pass the bus as a group (MUX / MCP / FIFO).
module unsafe_multi_bit_crossing (
    output logic [1:0] state_rx,
    input  logic [1:0] state_tx,   // e.g. IDLE=2'b00, WRITE=2'b11, READ=2'b10
    input  logic clk2, rst_n
);
    logic sa1, sa2, sb1, sb2;      // two independent 2-FF synchronizers
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n) {sa2, sa1} <= '0;
        else        {sa2, sa1} <= {sa1, state_tx[1]};   // bit 1
    always_ff @(posedge clk2 or negedge rst_n)
        if (!rst_n) {sb2, sb1} <= '0;
        else        {sb2, sb1} <= {sb1, state_tx[0]};   // bit 0
    assign state_rx = {sa2, sb2};  // can be a MIXTURE of old and new!
endmodule
