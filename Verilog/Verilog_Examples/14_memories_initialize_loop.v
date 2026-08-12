integer i;
initial begin
  for (i = 0; i < 16; i = i + 1)
    mem[i] = i;
end
