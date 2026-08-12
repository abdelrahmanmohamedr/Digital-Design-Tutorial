always @(*) begin
  case (sel)
    2'b00:   y = a;
    2'b01:   y = b;
    2'b10:   y = c;
    default: y = d;
  endcase
end
