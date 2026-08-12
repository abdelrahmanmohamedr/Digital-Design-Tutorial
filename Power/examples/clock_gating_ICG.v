module clock_gateing_ICG (
    input clk,
    input in,
    input enb,
    output reg out
);
    reg gated_clock = clk & latched_enb;
    reg latched_enb;

    always @(*) begin
        if (!clk) begin
            latched_enb <= enb;
        end
    end

    always @(posedge gated_clock) begin
        out <= in;
    end 
endmodule