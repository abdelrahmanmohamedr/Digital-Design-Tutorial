// Basic module syntax with port list
module <name> ([port_list]);    //port list is optional
	//module body
endmodule

// Basic module syntax without port list
module <name>;
	//module body
endmodule

//example for the module
module alu (
    input [3:0] a,  //four bits signal -from 0 LSB to 3 MSB-
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

<module name> <instantiation name> [port definition];

module add (
    input signed [3:0]  first,
    input signed [3:0]  second,
    output signed [3:0] out,
    output carry
);

//addition implementation
endmodule

module alu (
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [3:0] c,
    output carry_out
);

// 1. Instantiation by Position (Order)
add add_inst1 (a, b, c, carry_out);  
// Order of the ports IS important here.
// They must exactly match the order defined in the `add` module: 
// 1st: first, 2nd: second, 3rd: out, 4th: carry.
// The names of the signals being passed do not have to be the same.

// 2. Instantiation by Name
add add_inst2 (.first(a), .second(b), .out(c), .carry(carry_out));  
// Order of the ports is NOT important here. 
// We explicitly state which signal connects to which port.
// For example, this would also be perfectly valid and work exactly the same:
// add add_inst2 (.out(c), .carry(carry_out), .first(a), .second(b));

// alu implementation
endmodule