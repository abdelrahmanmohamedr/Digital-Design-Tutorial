// Non-blocking - CORRECT swap
always @(posedge clk) begin
  a <= b;
  b <= a;  // reads the OLD a,
end        // scheduled, not written yet

// Result: a and b are swapped,
// exactly like two real flip-flops.
