// Step 1: Declare top-level testbench module
module adder_tb ();

    // Step 2: Declare signals for DUT connection
    reg clk, reset;
    reg signed [3:0] A, B;
    wire signed [4:0] C;
    integer error_count, correct_count;
    localparam MAXPOS = 7, ZERO = 0, MAXNEG = -8;

    // Step 3: Instantiate DUT
    adder DUT (.clk(clk), .reset(reset), .A(A), .B(B), .C(C));

    // Step 4: Generate stimuli (clock generation)
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Step 4: Reusable stimulus task
    task assert_reset;
        reset = 1;
        expected_res(0);
        reset = 0;
    endtask
