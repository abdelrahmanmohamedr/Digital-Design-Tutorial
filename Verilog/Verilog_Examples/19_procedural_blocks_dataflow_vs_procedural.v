// Dataflow - continuous, always active
assign y = a & b;      // y updates instantly whenever a or b changes

// Procedural - executes when triggered
always @(*) begin
    y = a & b;              // same logic, but written procedurally
end
