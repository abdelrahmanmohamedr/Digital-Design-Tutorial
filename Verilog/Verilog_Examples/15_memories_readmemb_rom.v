module rom_with_file(
    input [2:0] addr,
    output [1:0] data
    );

    reg [1:0] rom [0:7];

    initial
        $readmemb("truth_table.mem", rom);

    assign data = rom[addr];
endmodule
