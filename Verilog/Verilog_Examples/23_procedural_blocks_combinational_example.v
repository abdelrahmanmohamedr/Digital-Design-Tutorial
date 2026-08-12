//Combinational Element Design Example
module combo ( input   a,
                input   b,
                input   c,
                input   d,
                output reg o);  // Output must be 'reg' type for procedural assignment

  // Level-sensitive always block: Triggers when ANY input changes
  // This infers combinational logic (no clock, no memory elements)
  always @ (a or b or c or d) begin
    // Combinational expression: o = NOT((a AND b) OR (c XOR d))
    o = ~((a & b) | (c^d));
  end

endmodule
