module Dual_Edge_Triggered_FF (
    input clock,
    input rst,
    input q,
    output reg d
);

always@(posedge clock or negedge clock) begin
    if (rst) begin
        d <= 0;
    end else begin
        d <= q;
    end
end
    
endmodule