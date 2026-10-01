// ============================================================================
// Project Name : ALU_4bit_SE190745 (Resource-Shared 4-Bit ALU)
// Module Name  : muldiv_unit
// Author       : Le Ky Dung
// Roll Number  : SE190745
// ============================================================================
`timescale 1ns / 1ps

module muldiv_unit(
    input            clk,
    input            rst,
    input            start,
    input            is_muldiv,
    input            is_div,
    input      [3:0] a,
    input      [3:0] b,
    input      [3:0] sum,
    input            c4,
    output reg [3:0] add_a,
    output reg [3:0] add_b,
    output reg [3:0] hi,
    output reg [3:0] lo,
    output reg       busy,
    output reg       done,
    output reg       div_by_zero
);
    reg [3:0] acc;
    reg [3:0] q;
    reg [3:0] m;
    reg [1:0] count;
    reg       op_div;

    wire [3:0] acc_shift = {acc[2:0], q[3]};

    // Điều khiển đường dữ liệu gửi sang bộ cộng/trừ dùng chung
    always @(*) begin
        if (op_div) begin
            add_a = acc_shift;
            add_b = m;
        end else begin
            add_a = acc;
            add_b = q[0] ? m : 4'b0000;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc         <= 4'b0000;
            q           <= 4'b0000;
            m           <= 4'b0000;
            hi          <= 4'b0000;
            lo          <= 4'b0000;
            count       <= 2'b00;
            op_div      <= 1'b0;
            busy        <= 1'b0;
            done        <= 1'b0;
            div_by_zero <= 1'b0;
        end else begin
            done <= 1'b0;
            if (!busy) begin
                if (start && is_muldiv) begin
                    if (is_div && (b == 4'b0000)) begin
                        div_by_zero <= 1'b1;
                        done        <= 1'b1;
                    end else begin
                        div_by_zero <= 1'b0;
                        busy        <= 1'b1;
                        op_div      <= is_div;
                        acc         <= 4'b0000;
                        q           <= a;
                        m           <= b;
                        count       <= 2'b00;
                    end
                end
            end else begin
                if (!op_div) begin
                    // Thuật toán Nhân dịch-cộng 4 chu kỳ
                    if (count == 2'd3) begin
                        {hi, lo} <= {c4, sum, q[3:1]};
                        busy     <= 1'b0;
                        done     <= 1'b1;
                    end else begin
                        {acc, q} <= {c4, sum, q[3:1]};
                        count    <= count + 2'b01;
                    end
                end else begin
                    // Thuật toán Chia phục hồi 4 chu kỳ
                    if (count == 2'd3) begin
                        hi   <= c4 ? sum : acc_shift;
                        lo   <= {q[2:0], c4};
                        busy <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        acc   <= c4 ? sum : acc_shift;
                        q     <= {q[2:0], c4};
                        count <= count + 2'b01;
                    end
                end
            end
        end
    end

endmodule