module adder #(parameter WIDTH = 8, PARAM_LENGTH = 4) (
 input wire [WIDTH-1:0] a,
 input wire [WIDTH-1:0] b,
 output wire [WIDTH-1:0] sum
);

 // Assign a part-select of original parameter
 localparam LENGTH = 2 + PARAM_LENGTH[1:0];

 assign sum = a + b;

 initial begin
 $display("Length = %d", LENGTH);
 end
endmodule

module tb;
 // Statements

 // Update parameter length to 6, and localparam should get 2 + 2'b10 = 4
 adder #(.WIDTH(16), .PARAM_LENGTH(6)) add_instance2 ( ... );
endmodule
