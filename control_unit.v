// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : control_unit
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module control_unit(
    input  [3:0] opcode,
    output       sub,
    output       arith,
    output       is_shl,
    output       is_shr,
    output       is_div,
    output       is_muldiv
);
    wire n3 = ~opcode[3];
    wire n2 = ~opcode[2];
    wire n1 = ~opcode[1];
    wire n0 = ~opcode[0];

    assign sub       = n3 & n2 & n1 & opcode[0];          // 0001 (SUB)
    assign arith     = n3 & n2 & n1;                      // 000x (ADD, SUB)
    assign is_shl    = n3 & opcode[2] & opcode[1] & n0;   // 0110 (SHL)
    assign is_shr    = n3 & opcode[2] & opcode[1] & opcode[0]; // 0111 (SHR)
    assign is_div    = opcode[3] & n2 & n1 & opcode[0];   // 1001 (DIV)
    assign is_muldiv = opcode[3] & n2 & n1;               // 100x (MUL, DIV)

endmodule