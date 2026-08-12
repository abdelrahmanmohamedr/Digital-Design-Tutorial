//Syntax:
always @(sensitivity_list) begin
    // statements execute whenever a listed signal changes
end


//Two common forms:
always @(posedge clk)   // triggers only on rising edge of clk -> sequential logic
always @(*)                 // triggers whenever ANY input inside changes -> combinational logic
