module shift_reg (
  input  wire clk,
  input  wire d,
  output reg  q0, q1, q2
);
  always @(posedge clk) begin
    q0 <= d;    // all three right-hand sides
    q1 <= q0;   // are read using OLD values,
    q2 <= q1;   // then updated together
  end
endmodule
