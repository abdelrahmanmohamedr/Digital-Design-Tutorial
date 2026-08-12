//Overriding Parameters at Instantiation
counter #(.WIDTH(16)) big_counter (.count(count_out));

module tb;

    // Module instantiation override
    design_ip #(.BUS_WIDTH(64), .DATA_WIDTH(128)) d0 ( [port list]);

    // Use of defparam to override
    defparam d0.FIFO_DEPTH = 128; //commonly used in testbench simulations to quickly update the design parameters without having to reinstantiate the module.

endmodule
