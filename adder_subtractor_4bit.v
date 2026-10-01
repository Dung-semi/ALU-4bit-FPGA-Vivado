// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : adder_subtractor_4bit
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module adder_subtractor_4bit(
    input  [3:0] a,
    input  [3:0] b,
    input        sub,
    output [3:0] sum,
    output       c3,
    output       c4
);
    wire [3:0] b_inv;
    wire       c1, c2;

    assign b_inv = b ^ {4{sub}};

    full_adder fa0 (.a(a[0]), .b(b_inv[0]), .cin(sub), .sum(sum[0]), .cout(c1));
    full_adder fa1 (.a(a[1]), .b(b_inv[1]), .cin(c1),  .sum(sum[1]), .cout(c2));
    full_adder fa2 (.a(a[2]), .b(b_inv[2]), .cin(c2),  .sum(sum[2]), .cout(c3));
    full_adder fa3 (.a(a[3]), .b(b_inv[3]), .cin(c3),  .sum(sum[3]), .cout(c4));

endmodule