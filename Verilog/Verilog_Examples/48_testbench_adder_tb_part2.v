    // Step 4: Initialize testbench variables and generate stimuli
    initial begin
        error_count = 0;
        correct_count = 0;
        A = 0; B = 0;

        assert_reset;

        A = MAXPOS; B = MAXNEG; expected_res(-1);   // Edge case: opposite extremes
        A = MAXPOS; B = MAXPOS; expected_res(14);   // Max positive overflow into wider result
        A = MAXNEG; B = MAXNEG; expected_res(-16);  // Max negative overflow into wider result
        A = ZERO;   B = ZERO;   expected_res(ZERO); // Baseline case

        $display("%t: Done. Errors=%0d, Correct=%0d", $time, error_count, correct_count);
        $stop;
    end

    // Step 5: Write checker and monitor code
    task expected_res([4:0] expected_out);
        @(negedge clk);
        if (expected_out !== C) begin
            error_count++;
            $display("%t: Error: A=%0d, B=%0d -> expected C=%0d, got C=%0d",
                $time, A, B, expected_out, C);
        end else begin
            correct_count++;
        end
    endtask

endmodule
