// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : alu_4bit (Top-Level Module)
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module alu_4bit(
    input            clk,
    input            rst,
    input            start,
    input      [3:0] opcode,
    input      [3:0] a,
    input      [3:0] b,
    output reg [7:0] result,
    output           carry,
    output           zero,
    output           overflow,
    output           negative,
    output           busy,
    output           done,
    output           div_by_zero
);
    wire sub, arith, is_shl, is_shr, is_div, is_muldiv;

    control_unit ctrl (
        .opcode(opcode),
        .sub(sub),
        .arith(arith),
        .is_shl(is_shl),
        .is_shr(is_shr),
        .is_div(is_div),
        .is_muldiv(is_muldiv)
    );

    wire [3:0] add_a, add_b, sum;
    wire       c3, c4;

    wire [3:0] mux_adder_a   = busy ? add_a  : a;
    wire [3:0] mux_adder_b   = busy ? add_b  : b;
    wire       mux_adder_sub = busy ? is_div : sub;

    adder_subtractor_4bit adder_sub_u (
        .a(mux_adder_a),
        .b(mux_adder_b),
        .sub(mux_adder_sub),
        .sum(sum),
        .c3(c3),
        .c4(c4)
    );

    wire [3:0] out_and, out_or, out_xor, out_not;

    logic_unit_4bit logic_u (
        .a(a),
        .b(b),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
        .out_not(out_not)
    );

    wire [3:0] out_shl, out_shr;

    shifter_4bit shifter_u (
        .a(a),
        .out_shl(out_shl),
        .out_shr(out_shr)
    );

    wire [3:0] hi, lo;

    muldiv_unit muldiv_u (
        .clk(clk),
        .rst(rst),
        .start(start),
        .is_muldiv(is_muldiv),
        .is_div(is_div),
        .a(a),
        .b(b),
        .sum(sum),
        .c4(c4),
        .add_a(add_a),
        .add_b(add_b),
        .hi(hi),
        .lo(lo),
        .busy(busy),
        .done(done),
        .div_by_zero(div_by_zero)
    );

    always @(*) begin
        case (opcode)
            4'b0000, 4'b0001: result = {4'b0000, sum};
            4'b0010:          result = {4'b0000, out_and};
            4'b0011:          result = {4'b0000, out_or};
            4'b0100:          result = {4'b0000, out_xor};
            4'b0101:          result = {4'b0000, out_not};
            4'b0110:          result = {4'b0000, out_shl};
            4'b0111:          result = {4'b0000, out_shr};
            4'b1000, 4'b1001: result = {hi, lo};
            default:          result = 8'b00000000;
        endcase
    end

    flag_unit flags_u (
        .a(a),
        .result(result),
        .c3(c3),
        .c4(c4),
        .arith(arith),
        .is_shl(is_shl),
        .is_shr(is_shr),
        .is_muldiv(is_muldiv),
        .carry(carry),
        .zero(zero),
        .overflow(overflow),
        .negative(negative)
    );

endmodule