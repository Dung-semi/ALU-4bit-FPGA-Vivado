// ============================================================================
// Project Name : ALU_4bit_SE190745
// Module Name  : alu_4bit_tb (Self-Checking Testbench)
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module alu_4bit_tb;

    reg        clk;
    reg        rst;
    reg        start;
    reg  [3:0] opcode;
    reg  [3:0] a;
    reg  [3:0] b;

    wire [7:0] result;
    wire       carry;
    wire       zero;
    wire       overflow;
    wire       negative;
    wire       busy;
    wire       done;
    wire       div_by_zero;

    integer error_count = 0;

    alu_4bit uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .opcode(opcode),
        .a(a),
        .b(b),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow),
        .negative(negative),
        .busy(busy),
        .done(done),
        .div_by_zero(div_by_zero)
    );

    always #5 clk = ~clk;

    task check_result;
        input [7:0] exp_res;
        input [127:0] op_name;
        begin
            if (result !== exp_res) begin
                $display("[FAIL] %0s | a=%0d, b=%0d | Expected=%h, Got=%h", op_name, a, b, exp_res, result);
                error_count = error_count + 1;
            end else begin
                $display("[OK]   %0s | a=%0d, b=%0d | Result=%h | C=%b Z=%b V=%b N=%b", 
                         op_name, a, b, result, carry, zero, overflow, negative);
            end
        end
    endtask

    initial begin
        $display("================================================================");
        $display(" STUDENT NAME : LE KY DUNG");
        $display(" ROLL NUMBER  : SE190745");
        $display(" PROJECT      : 4-BIT ALU SELF-CHECKING TESTBENCH");
        $display("================================================================");

        clk = 0; rst = 1; start = 0; opcode = 4'b0000; a = 4'd0; b = 4'd0;
        #20;
        rst = 0;

        $display("--- PART 1: COMBINATIONAL OPERATIONS (OPCODES 0 TO 7) ---");
        opcode = 4'b0000; a = 4'd5;  b = 4'd3;  #20; check_result(8'h08, "ADD (5 + 3)");
        opcode = 4'b0001; a = 4'd9;  b = 4'd4;  #20; check_result(8'h05, "SUB (9 - 4)");
        opcode = 4'b0010; a = 4'd12; b = 4'd10; #20; check_result(8'h08, "AND (12 & 10)");
        opcode = 4'b0011; a = 4'd12; b = 4'd3;  #20; check_result(8'h0f, "OR  (12 | 3)");
        opcode = 4'b0100; a = 4'd12; b = 4'd10; #20; check_result(8'h06, "XOR (12 ^ 10)");
        opcode = 4'b0101; a = 4'd10; b = 4'd10; #20; check_result(8'h05, "NOT (~10)");
        opcode = 4'b0110; a = 4'd3;  b = 4'd10; #20; check_result(8'h06, "SHL (3 << 1)");
        opcode = 4'b0111; a = 4'd12; b = 4'd10; #20; check_result(8'h06, "SHR (12 >> 1)");

        $display("--- PART 2: SEQUENTIAL MUL/DIV OPERATIONS (OPCODES 8 TO 9) ---");
        opcode = 4'b1000; a = 4'd7; b = 4'd6;
        start = 1; #10; start = 0;
        @(posedge done); #10;
        check_result(8'h2a, "MUL (7 * 6)");

        #10;
        opcode = 4'b1001; a = 4'd13; b = 4'd3;
        start = 1; #10; start = 0;
        @(posedge done); #10;
        check_result(8'h14, "DIV (13 / 3)");

        #10;
        opcode = 4'b1001; a = 4'd8; b = 4'd0;
        start = 1; #10; start = 0;
        #20;
        if (div_by_zero === 1'b1)
            $display("[OK]   DIV_BY_ZERO (8 / 0) | div_by_zero=%b | Output Held=%h", div_by_zero, result);
        else begin
            $display("[FAIL] DIV_BY_ZERO flag not asserted!");
            error_count = error_count + 1;
        end

        $display("================================================================");
        if (error_count == 0)
            $display(" PASS: ALL 11 TEST CASES VERIFIED SUCCESSFULLY (0 ERRORS)");
        else
            $display(" FAIL: FOUND %0d ERRORS", error_count);
        $display("================================================================");
        #50;
        $finish;
    end

endmodule