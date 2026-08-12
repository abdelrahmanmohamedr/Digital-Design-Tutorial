module operators_example;

  reg [3:0] A = 4'b1010;   // A = 10
  reg [3:0] B = 4'b0110;   // B = 6

  initial begin

    // ---- Bitwise ----
    $display("~A     = %b", ~A);       // ~A     = 0101  (5)
    $display("A & B  = %b", A & B);    // A & B  = 0010  (2)
    $display("A | B  = %b", A | B);    // A | B  = 1110  (14)
    $display("A ^ B  = %b", A ^ B);    // A ^ B  = 1100  (12)

    // ---- Logical ----
    $display("A&&B   = %b", A && B);   // A&&B   = 1
    $display("A||B   = %b", A || B);   // A||B   = 1
    $display("!A     = %b", !A);       // !A     = 0

    // ---- Reduction ----
    $display("&A     = %b", &A);       // &A     = 0   (AND of 1,0,1,0)
    $display("|A     = %b", |A);       // |A     = 1
    $display("^A     = %b", ^A);       // ^A     = 0

    // ---- Relational ----
    $display("A>B    = %b", A > B);    // A>B    = 1
    $display("A==B   = %b", A == B);   // A==B   = 0

    // ---- Arithmetic ----
    $display("A+B    = %d", A + B);    // A+B    = 16
    $display("A-B    = %d", A - B);    // A-B    = 4
    $display("A*B    = %d", A * B);    // A*B    = 60
    $display("A%%B   = %d", A % B);    // A%B    = 4

    // ---- Shift ----
    $display("A<<1   = %b", A << 1);   // A<<1   = 0100  (10100 truncated to 4 bits)
    $display("A>>1   = %b", A >> 1);   // A>>1   = 0101  (5)

    // ---- Concatenation ----
    $display("{A,B}  = %b", {A, B});   // {A,B}  = 10100110  (166)

    // ---- Replication ----
    $display("{2{A}} = %b", {2{A}});   // {2{A}} = 10101010  (170)

    // ---- Conditional ----
    $display("sel?A:B= %d", 1'b1 ? A : B); // sel?A:B = 10 (A chosen)

  end

endmodule
