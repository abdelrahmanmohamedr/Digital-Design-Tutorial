// GOOD: complete & synthesizable
always @(*) begin
  y = 1'b0;      // safe default
  if (sel)
    y = a;
  else
    y = b;
end
