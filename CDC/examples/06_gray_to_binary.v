// Gray -> Binary conversion.
// bin[i] = XOR-reduce(gray >> i).
// The naive variable part-select (gray[SIZE-1:i]) is illegal Verilog -
// shifting the whole vector and reducing works and synthesizes well:
// the tool optimizes the constant-0 XORs away.
module gray_to_binary #(parameter SIZE = 4) (
    output logic [SIZE-1:0] bin,
    input  logic [SIZE-1:0] gray
);
    always_comb
        for (int i = 0; i < SIZE; i++)
            bin[i] = ^(gray >> i);
endmodule
