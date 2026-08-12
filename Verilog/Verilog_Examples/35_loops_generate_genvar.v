module reduced_xor_gen (
    input logic [7:0] a,
    output logic y
);

logic [7:0] p;

assign p[0] = a[0];

// replicated cascading-chain structure
generate
    genvar i;
    for (i = 1; i < 7; i = i + 1)
        assign p[i] = a[i] ^ p[i - 1];
endgenerate

assign y = p[7 - 1];

endmodule
