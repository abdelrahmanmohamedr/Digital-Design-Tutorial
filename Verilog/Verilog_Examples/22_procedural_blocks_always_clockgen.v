// No sensitivity list and no delay - simulation hangs
// always block is started at time 0 units But when is it supposed to be repeated?
// There is no time control, and hence it will stay and be repeated at 0 time units only. This continues
// in a loop and simulation will hang
always clk = ~clk;


// CORRECT for testbenches: Explicit delay creates clock with 20ns period
// Toggles every 10ns: high for 10ns, low for 10ns
always #10 clk = ~clk;
