//example for the module
module alu (
    input [3:0] a,   //four bits signal -from 0 LSB to 3 MSB-
    input [3:0] b,
    output [3:0] c,
    output carry_out //one bit signal
);

// alu implementation
endmodule

//port type can be defined in the module itself
module alu (a, b, c, carry_out);

    input [3:0] a,
    input [3:0] b,
    output [3:0] c,
    output carry_out

// alu implementation
endmodule

//for correct arithmatic operation operands have to be signed
module alu (
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [3:0] c,
    output carry_out
);

// alu implementation
endmodule
