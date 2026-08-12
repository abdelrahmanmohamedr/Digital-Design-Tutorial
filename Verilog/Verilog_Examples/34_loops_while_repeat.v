// while: find the first set bit
i = 0;
while (i < 8 && !data[i])
  i = i + 1;

// repeat: generate 10 clock pulses
repeat (10) begin
  clk = ~clk;
  #5;
end
