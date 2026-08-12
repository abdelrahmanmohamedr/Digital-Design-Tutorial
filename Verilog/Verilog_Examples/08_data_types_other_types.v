module testbench;
    integer   int_a;         // Integer variable (32-bit signed)
    real      real_b;        // Real variable (64-bit floating point)
    time      time_c;        // Time variable (64-bit unsigned)

    initial begin
    int_a  = 32'hcafe_1234;   // Assign hexadecimal value to integer
    real_b    = 0.1234567;    // Assign floating point value to real

    #20;                     // Advance simulation time by 20 units
    time_c    = $time;       // Capture current simulation time ($time returns time type)

    // Print all variables using $display with appropriate format specifiers
    $display ("int_a  = 0x%0h", int_a);   // %0h = hexadecimal format
    $display ("real_b = %0.5f", real_b);  // %0.5f = 5 decimal places
    $display ("time_c = %0t", time_c);    // %0t = time format
    end
endmodule
