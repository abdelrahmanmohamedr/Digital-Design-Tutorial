// BAD: latch inferred on y
always @(a, sel) begin
  if (sel)
    y = a;
  // no else -> y holds old value
  // 'b' missing from sensitivity list
end
