module ifu(
    output [31:0] instruction,
    output branch_taken,
    output [31:0] pc_seq_out,

    // Data signals
    input [15:0] imm16,
    input [25:0] addr26,
    input [31:0] pc_reg,
    input [31:0] pc_mem,

    // Status signals
    input zero,
    input st_Z,

    // Control signals
    input [1:0] pc_select,
    input is_jump,
    input status_branch,
    input need_st_Z,
    input zero_branch,
    input need_zero,

    input clk
);

    reg [31:0] pc;  // even though our addresses are 8 bits
    wire [31:0] pc_in, pc_seq, pc_branch, pc_offset, pc_addr26, sext_imm16;
    wire take_zero_branch, take_status_branch, zero_satisfied, st_Z_satisfied;

    rom imemory(instruction, pc);
    signext16_32 sext_imm(sext_imm16, imm16);
    mux4 #(32) pc_branch_mux(pc_branch, pc_offset, pc_addr26, pc_reg, pc_mem, pc_select);
    mux2 #(32) pc_in_mux(pc_in, pc_seq, pc_branch, branch_taken);

    // branch_taken calculation
    or(branch_taken, is_jump, take_zero_branch, take_status_branch);
    and(take_zero_branch, zero_branch, zero_satisfied);
    and(take_status_branch, status_branch, st_Z_satisfied);
    xnor(zero_satisfied, zero, need_zero);
    xnor(st_Z_satisfied, st_Z, need_st_Z);

    assign pc_seq = pc + 4;
    assign pc_seq_out = pc_seq;
    assign pc_offset = pc_seq + (sext_imm16 << 2);
    assign pc_addr26 = {pc[31:28], addr26, 2'b00};

    initial begin
        pc = -4;
    end

    always @(negedge clk) begin
        pc = pc_in;
        if (pc > 1000) begin
            pc = 1000;  // so we don't wrap around
        end
    end

endmodule
