`include "_const.v"

module control(
    input [31:0] instruction,

    output reg reg_write,
    output reg reg_dst,
    output reg write_reg31,
    output reg link,
    output reg alu_src,
    output reg [2:0] alu_op,
    output reg ext_op,
    output reg mem_write,
    output reg mem_to_reg,
    output reg is_jump,
    output reg zero_branch,
    output reg need_zero,
    output reg status_branch,
    output reg need_st_Z,
    output reg [1:0] pc_select
);

    wire [5:0] opcode, func;

    // Maybe pass just there 2 signals?
    // This would mean rewriting the control tests though
    assign opcode = instruction[31:26];
    assign func = instruction[5:0];

    initial begin
        reg_write = 0;
        reg_dst = 0;
        write_reg31 = 0;
        link = 0;
        alu_src = 0;
        alu_op = 3'b0;
        ext_op = 0;
        mem_write = 0;
        mem_to_reg = 0;
        is_jump = 0;
        zero_branch = 0;
        need_zero = 0;
        status_branch = 0;
        need_st_Z = 0;
        pc_select = 2'b0;
    end

    // Doing it the easy way now, will rewrite if in the future it seems useful to do
    always @(instruction) begin

        // Reasonable defaults
        reg_write = 0;
        reg_dst = 0;
        write_reg31 = 0;
        link = 0;
        alu_src = 0;
        alu_op = `OP_ADD;
        ext_op = 0;
        mem_write = 0;
        mem_to_reg = 0;
        is_jump = 0;
        zero_branch = 0;
        need_zero = 0;
        status_branch = 0;
        need_st_Z = 0;
        pc_select = 2'b0;

        case (opcode)
            `OPCODE_ADDI: begin
                reg_write = 1;
                reg_dst = 1;
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
            end
            `OPCODE_ANDI: begin
                reg_write = 1;
                reg_dst = 1;
                alu_src = 1;
                alu_op = `OP_AND;
            end
            `OPCODE_BALMN: begin
                reg_dst = 1;
                link = 1;
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                status_branch = 1;
                pc_select = 2'b11;
            end
            `OPCODE_BALMZ: begin
                reg_dst = 1;
                link = 1;
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                status_branch = 1;
                need_st_Z = 1;
                pc_select = 2'b11;
            end
            `OPCODE_BEQ: begin
                alu_op = `OP_SUB;
                zero_branch = 1;
                need_zero = 1;
                pc_select = 2'b00;
            end
            `OPCODE_BEQAL: begin
                write_reg31 = 1;
                link = 1;
                alu_op = `OP_SUB;
                zero_branch = 1;
                need_zero = 1;
                pc_select = 2'b00;
            end
            `OPCODE_BMN: begin
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                status_branch = 1;
                need_st_Z = 0;
                pc_select = 2'b11;
            end
            `OPCODE_BMZ: begin
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                status_branch = 1;
                need_st_Z = 1;
                pc_select = 2'b11;
            end
            `OPCODE_BNE: begin
                alu_op = `OP_SUB;
                zero_branch = 1;
                need_zero = 0;
                pc_select = 2'b00;
            end
            `OPCODE_BNEAL: begin
                write_reg31 = 1;
                link = 1;
                alu_op = `OP_SUB;
                zero_branch = 1;
                need_zero = 0;
                pc_select = 2'b00;
            end
            `OPCODE_JALM: begin
                reg_dst = 1;
                link = 1;
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                is_jump = 1;
                pc_select = 2'b11;
            end
            `OPCODE_JALPC: begin
                reg_dst = 1;
                link = 1;
                is_jump = 1;
                pc_select = 2'b00;
            end
            `OPCODE_JM: begin
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                is_jump = 1;
                pc_select = 2'b11;
            end
            `OPCODE_JPC: begin
                is_jump = 1;
                pc_select = 2'b00;
            end
            `OPCODE_LW: begin
                reg_write = 1;
                reg_dst = 1;
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                mem_to_reg = 1;
            end
            `OPCODE_ORI: begin
                reg_write = 1;
                reg_dst = 1;
                alu_src = 1;
                alu_op = `OP_OR;
            end
            `OPCODE_SW: begin
                alu_src = 1;
                alu_op = `OP_ADD;
                ext_op = 1;
                mem_write = 1;
            end
            `OPCODE_BALN: begin
                write_reg31 = 1;
                link = 1;
                status_branch = 1;
                pc_select = 2'b01;
            end
            `OPCODE_BALZ: begin
                write_reg31 = 1;
                link = 1;
                status_branch = 1;
                need_st_Z = 1;
                pc_select = 2'b01;
            end
            `OPCODE_BN: begin
                status_branch = 1;
                pc_select = 2'b01;
            end
            `OPCODE_BZ: begin
                status_branch = 1;
                need_st_Z = 1;
                pc_select = 2'b01;
            end
            `OPCODE_JAL: begin
                write_reg31 = 1;
                link = 1;
                is_jump = 1;
                pc_select = 2'b01;
            end
            `OPCODE_J: begin
                reg_write = 0;
                is_jump = 1;
                status_branch = 0;
                pc_select = 2'b01;
            end

            `OPCODE_RTYPE: begin
                // see below
            end
        endcase
    end

    always @(instruction) if (opcode == `OPCODE_RTYPE) begin

        case (func)
            `FUNC_ADD: begin
                reg_write = 1;
                alu_op = `OP_ADD;
            end
            `FUNC_AND: begin
                reg_write = 1;
                alu_op = `OP_AND;
            end
            `FUNC_BALRN: begin
                link = 1;
                status_branch = 1;
                pc_select = 2'b10;
            end
            `FUNC_BALRZ: begin
                link = 1;
                status_branch = 1;
                need_st_Z = 1;
                pc_select = 2'b10;
            end
            `FUNC_BRN: begin
                status_branch = 1;
                pc_select = 2'b10;
            end
            `FUNC_BRZ: begin
                status_branch = 1;
                need_st_Z = 1;
                pc_select = 2'b10;
            end
            `FUNC_JALR: begin
                link = 1;
                is_jump = 1;
                pc_select = 2'b10;
            end
            `FUNC_JR: begin
                is_jump = 1;
                pc_select = 2'b10;
            end
            `FUNC_NOR: begin
                reg_write = 1;
                alu_op = `OP_NOR;
            end
            `FUNC_OR: begin
                reg_write = 1;
                alu_op = `OP_OR;
            end
            `FUNC_SLT: begin
                reg_write = 1;
                alu_op = `OP_SLT;
            end
            `FUNC_SLL: begin
                reg_write = 1;
                alu_op = `OP_SLL;
            end
            `FUNC_SRL: begin
                reg_write = 1;
                alu_op = `OP_SRL;
            end
            `FUNC_SUB: begin
                reg_write = 1;
                alu_op = `OP_SUB;
            end
        endcase
    end



endmodule
