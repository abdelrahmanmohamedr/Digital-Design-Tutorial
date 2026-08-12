module design_ip
    #(parameter BUS_WIDTH=32,
      parameter DATA_WIDTH=64) (

    input [BUS_WIDTH-1:0] addr,
    // Other port declarations
);

parameter MSB = 7;    // MSB is a parameter with a constant value 7
parameter REAL = 4.5; // REAL holds a real number

parameter FIFO_DEPTH = 256,
 MAX_WIDTH = 32; // Declares two parameters

parameter [7:0] f_const = 2'b3; // 2 bit value is converted to 8 bits; 8'b3
