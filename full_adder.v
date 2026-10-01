// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : full_adder
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire p, g, p_cin;

    xor u_xor1 (p, a, b);
    xor u_xor2 (sum, p, cin);
    and u_and1 (g, a, b);
    and u_and2 (p_cin, p, cin);
    or  u_or1  (cout, g, p_cin);

endmodule