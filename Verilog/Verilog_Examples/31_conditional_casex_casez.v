always @(*) begin
  casez (req)
    4'b1???: grant = 4'b1000;  // highest priority
    4'b01??: grant = 4'b0100;
    4'b001?: grant = 4'b0010;
    4'b0001: grant = 4'b0001;
    default: grant = 4'b0000;
  endcase
end
