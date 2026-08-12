integer i;
reg [7:0] mem [0:15];

initial begin
  for (i = 0; i < 16; i = i + 1)
    mem[i] = i;  // fills mem[0]..mem[15]
end
