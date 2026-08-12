module clock_gateing_v0 (
    input clk,
    input in,
    input enb,
    output reg out
);
    reg gated_clock = clk & enb;

    always @(posedge gated_clock) begin
        out <= in;
    end 
endmodule