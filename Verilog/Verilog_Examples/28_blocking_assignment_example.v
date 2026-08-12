module comb_logic (
  input  wire a, b, c,
  output reg  y
);
  reg tmp;

  always @(*) begin
    tmp = a & b;   // evaluated first
    y   = tmp | c; // sees the NEW value of tmp
  end
endmodule
