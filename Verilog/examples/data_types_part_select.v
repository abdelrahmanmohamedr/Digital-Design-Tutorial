module data_types_part_select;
    wire [7:0] signal;  //8-bits signal

    assign signal[0] = 0;
    assign signal[1] = 1;
    assign signal[7:2] = 6'b111000;

    initial begin
        $monitor ("signal = %0b",signal);
    end
    
endmodule