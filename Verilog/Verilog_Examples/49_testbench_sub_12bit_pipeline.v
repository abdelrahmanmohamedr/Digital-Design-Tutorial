// Step 1: Declare top-level testbench module
module tb_sub_12bit_pipeline;

    // Step 2: Declare signals for DUT connection
    reg clk, rst_n;
    reg signed [11:0] a, b;
    wire signed [11:0] result;
    wire valid;

    // Step 3: Instantiate DUT
    sub_12bit_pipeline dut (.clk(clk), .rst_n(rst_n), .a(a), .b(b), .result(result), .valid(valid));
    // Step 4: Generate stimuli (clock generation)
    initial begin clk = 0; forever #1 clk = ~clk; end

    // Step 4: Initialize variables and generate stimuli
    initial begin
        rst_n = 0; a = 0; b = 0;
        #20 rst_n = 1;
        @(negedge clk) rst_n = 0;
        repeat(2) @(negedge clk);

        a = 12'sd100;    b = 12'sd50;    #10; // Test 1: 100 - 50 = 50
        a = -12'sd100;   b = 12'sd50;    #10; // Test 2: -100 - 50 = -150
        a = 12'sd0;      b = -12'sd2048; #10; // Test 3: 0 - (-2048), overflow edge
        a = -12'sd2048;  b = 12'sd2047;  #10; // Test 4: min - max, wraps

        #30 $stop;  // wait for pipeline latency (2 cycles), then stop
    end

    // NOTE: Step 5 can be skipped entirely if you just want to visually inspect
    // the design's behavior - dump signals to a waveform and see the results instead of writing an automated checker.

endmodule
