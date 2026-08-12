// Sequential Element Design Example
module tff (input       d,        // Data input: toggles output when high
            clk,      // Clock signal: triggers on rising edge
            rstn,     // Active-low asynchronous reset
      output reg  q);      // Output register (must be reg in always block)

  // Edge-sensitive always block: Triggered on posedge clk OR negedge rstn
  // This implements asynchronous reset behavior
  always @ (posedge clk or negedge rstn) begin
    if (!rstn)
      q <= 0;      // Asynchronous reset: Immediately set q to 0
    else
      // Synchronous behavior: Only evaluated at clock edges
      if (d)
        q <= ~q;   // Toggle output when d=1
      else
        q <= q;    // Hold output when d=0
  end
endmodule
