// Blocking - BROKEN swap
always @(posedge clk) begin
  a = b;
  b = a;  // reads the NEW a,
end        // not the original value

// Result: a == b == old_b
// The original value of a is lost.
