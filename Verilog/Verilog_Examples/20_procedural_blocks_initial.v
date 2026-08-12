initial begin
    clk = 0;            // initialize clock
    reset = 1;           // assert reset at time 0
    #10 reset = 0;        // deassert reset after 10 time units - Can contain delays (#) to schedule events over simulation time.
    #5  data_in = 8'hFF;  // apply test input at time 15
end

initial begin
    clk = 0;            // block A: starts at time 0
end

initial begin
    $display("Simulation started"); // block B: also starts at time 0
end
