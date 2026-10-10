// Binary -> Gray conversion.
// gray[i] = bin[i+1] ^ bin[i]; the MSB just passes through.
// One line, parameterized, synthesizes to an XOR tree.
module binary_to_gray #(parameter SIZE = 4) (
    output logic [SIZE-1:0] gray,
    input  logic [SIZE-1:0] bin
);
    assign gray = (bin >> 1) ^ bin;
endmodule
