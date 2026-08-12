/* Initialization */
reg arr1 [11:0];               // arr is a scalar reg array of depth=12, each 1-bit wide
wire [0:7] arr2 [3:0]          //arr is an 8-bit vector net with a depth of 4
reg [7:0] arr3 [0:1][0:3];   // arr is a 2D array rows=2,cols=4 each 8-bit wide

//You can initialize the elements of an array during declaration or later in the code
reg [3:0] regfile [0:7];   // 8 registers, each 4 bits wide
regfile[2] = 4'b1010;     // write register 2

arr1 = 0;                              // Illegal - All elements can't be assigned in a single go

arr2[0] = 8'ha2;      // Assign 0xa2 to index=0
arr3[1][2] = 8'hdd;   // Assign 0xdd to rows=1 cols=2
