module block_demo;
  reg [3:0] a, b;

  // Sequential block: order matters
  initial begin
    a = 4'd0;
    a = a + 1;  // runs after the line above
    a = a + 1;  // a is now 2
  end

  // Parallel block: all statements start together
  initial fork
    #5  b = 4'd1;  // both scheduled at time 0,
    #2  b = 4'd2;  // finishes when the last (#5) is done
  join
endmodule
