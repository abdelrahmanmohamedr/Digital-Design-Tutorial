// BAD: missing default -> inferred latch
always @(*) begin
  case (sel)
    2'b00: y = a;
    2'b01: y = b;
  endcase
end

// GOOD: every input value is covered
always @(*) begin
  case (sel)
    2'b00:   y = a;
    2'b01:   y = b;
    default: y = 1'b0;
  endcase
end
