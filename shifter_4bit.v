// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : shifter_4bit
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module shifter_4bit(
    input  [3:0] a,
    output [3:0] out_shl,
    output [3:0] out_shr
);
    assign out_shl = {a[2:0], 1'b0};
    assign out_shr = {1'b0, a[3:1]};

endmodule