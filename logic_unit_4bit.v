// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : logic_unit_4bit
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module logic_unit_4bit(
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] out_and,
    output [3:0] out_or,
    output [3:0] out_xor,
    output [3:0] out_not
);
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;
    assign out_not = ~a;

endmodule