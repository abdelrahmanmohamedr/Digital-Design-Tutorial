// always @(*) style
module mux2 (
  input  wire a, b, sel,
  output reg  y
);
  always @(*) begin
    case (sel)
      1'b0: y = a;
      1'b1: y = b;
    endcase
  end
endmodule
