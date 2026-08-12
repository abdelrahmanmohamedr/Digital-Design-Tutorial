module shift4 (
  input  wire clk, sin,
  output wire sout
);
  reg [3:0] sr;

  always @(posedge clk)
    sr <= {sr[2:0], sin};

  assign sout = sr[3];
endmodule
