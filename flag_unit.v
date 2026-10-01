// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : flag_unit
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module flag_unit(
    input  [3:0] a,
    input  [7:0] result,
    input        c3,
    input        c4,
    input        arith,
    input        is_shl,
    input        is_shr,
    input        is_muldiv,
    output       carry,
    output       zero,
    output       overflow,
    output       negative
);
    // Cờ Carry (C)
    assign carry = (arith & c4) | (is_shl & a[3]) | (is_shr & a[0]);

    // Cờ Overflow (V)
    assign overflow = arith & (c3 ^ c4);

    // Cờ Zero (Z)
    wire zero_4bit = ~(|result[3:0]);
    wire zero_8bit = ~(|result[7:0]);
    assign zero = is_muldiv ? zero_8bit : zero_4bit;

    // Cờ Negative (N)
    assign negative = is_muldiv ? 1'b0 : result[3];

endmodule