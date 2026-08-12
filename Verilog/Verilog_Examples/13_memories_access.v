//Accessing a Memory Word
mem[4] = 8'hAA;                    // write to word 4
$display("%h", mem[4]);        // read word 4

// Accessing a Bit Inside a Word
$display("%b", mem[4][3]);   // bit 3 of word 4
