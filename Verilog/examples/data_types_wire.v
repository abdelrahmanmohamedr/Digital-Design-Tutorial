module data_types_part_select;
    wire [7:0] signal;  //8-bits signal

    assign signal[0] = 0; //assign LSB
    assign signal[1] = 1; //assign bit number 1 
    assign signal[7:2] = 6'b111000; //assign bits from 2 to 7

    initial begin
        $monitor ("signal = %0b",signal); //display the signal
    end
    
endmodule