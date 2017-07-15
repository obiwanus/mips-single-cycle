`timescale 1ns/1ns
`include "_const.v"
`include "_assert.v"

module test_control;

    reg error = 0;

    reg [31:0] instruction;

    wire reg_write;
    wire reg_dst;
    wire write_reg31;
    wire link;
    wire alu_src;
    wire [2:0] alu_op;
    wire ext_op;
    wire mem_write;
    wire mem_to_reg;
    wire is_jump;
    wire zero_branch;
    wire need_zero;
    wire status_branch;
    wire need_st_Z;
    wire [1:0] pc_select;

    control MUT(instruction, reg_write, reg_dst, write_reg31, link, alu_src,
                alu_op, ext_op, mem_write, mem_to_reg, is_jump, zero_branch,
                need_zero, status_branch, need_st_Z, pc_select);

    initial begin

        // `assertEq(reg_write,        1)
        // `assertEq(reg_dst,          0)
        // `assertEq(write_reg31,      0)
        // `assertEq(link,             0)
        // `assertEq(alu_src,          0)
        // `assertEq(alu_op,     `OP_ADD)
        // `assertEq(ext_op,            )
        // `assertEq(mem_write,        0)
        // `assertEq(mem_to_reg,       0)
        // `assertEq(is_jump,          0)
        // `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        // `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // ALU instructions

        // addi    $s0, $zero, 0xFEFE
        instruction = 32'b00100000000100001111111011111110;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          1)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          1)
        `assertEq(alu_op,     `OP_ADD)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // sll     $s0, $s0, 16
        instruction = 32'b00000000000100001000010000000000;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_SLL)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // 000000 00000 10000 01000 00001 000010
        // srl     $s0, $s0, 16
        instruction = 32'b00000000000100000100000001000010;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_SRL)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // add     $t0, $zero, $zero
        instruction = 32'b00000000000000000100000000100000;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_ADD)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // 000000 10000 10001 01000 00000 100010
        // sub     $t0, $s0, $s1
        instruction = 32'b00000010000100010100000000100010;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_SUB)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // slt     $t1, $t0, $s1
        instruction = 32'b00000001000100010100100000101010;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_SLT)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // 000000 10000 10001 01000 00000 100100
        // and     $t0, $s0, $s1
        instruction = 32'b00000010000100010100000000100100;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_AND)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // andi    rt, rs, imm     rt = rs & zeroext(imm)
        instruction = 32'b00110010000010010000000011001111;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          1)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          1)
        `assertEq(alu_op,     `OP_AND)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // 001101 10000 01001 0000000011000000
        // ori     $t1, $s0, 0xC0
        instruction = 32'b00110110000010010000000011000000;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          1)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          1)
        `assertEq(alu_op,      `OP_OR)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // 000000 10000 10001 01000 00000 100101
        // or     $t0, $s0, $s1
        instruction = 32'b00000010000100010100000000100101;
        #1;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,      `OP_OR)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)

        // 000000 10000 10001 01000 00000 100111
        // nor    $t0, $s0, $s1
        instruction = 32'b00000010000100010100000000100111;
        #1;
        #1;
        `assertEq(reg_write,        1)
        `assertEq(reg_dst,          0)
        `assertEq(write_reg31,      0)
        `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_NOR)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        // `assertEq(pc_select,    2'b00)


        // JUMPS

        // 000010 00000000000000000000000100
        // j target26
        instruction = 32'b00001000000000000000000000000100;
        #1;
        `assertEq(reg_write,        0)
        // `assertEq(reg_dst,          0)
        // `assertEq(write_reg31,      0)
        // `assertEq(link,             0)
        // `assertEq(alu_src,          0)
        // `assertEq(alu_op,     `OP_AND)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        // `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          1)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        `assertEq(pc_select,    0'b01)

        // 000000 11111 00000 00000 00000 001000
        // jr $ra
        instruction = 32'b00000011111000000000000000001000;
        #1;
        `assertEq(reg_write,        0)
        // `assertEq(reg_dst,          0)
        // `assertEq(write_reg31,      0)
        // `assertEq(link,             0)
        // `assertEq(alu_src,          0)
        // `assertEq(alu_op,     `OP_AND)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        // `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          1)
        `assertEq(zero_branch,      0)
        // `assertEq(need_zero,         )
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        `assertEq(pc_select,    0'b10)

        // 000101 01010 01011 1111111111111100
        // bne     $t2, $t3, loop
        instruction = 32'b00010101010010111111111111111100;
        #1;
        `assertEq(reg_write,        0)
        // `assertEq(reg_dst,          0)
        // `assertEq(write_reg31,      0)
        // `assertEq(link,             0)
        `assertEq(alu_src,          0)
        `assertEq(alu_op,     `OP_SUB)
        // `assertEq(ext_op,            )
        `assertEq(mem_write,        0)
        // `assertEq(mem_to_reg,       0)
        `assertEq(is_jump,          0)
        `assertEq(zero_branch,      1)
        `assertEq(need_zero,        0)
        `assertEq(status_branch,    0)
        // `assertEq(need_st_Z,         )
        `assertEq(pc_select,    0'b00)  // select offset

        // // sw      $s0, 0($t0)

        // TODO: reassemble
        // instruction = 32'b00000000000000000100000000100000;
        // #1;
        // $stop;
        // `assertEq(reg_write,        0)
        // // `assertEq(reg_dst,          0)
        // // `assertEq(write_reg31,      0)
        // // `assertEq(link,             0)
        // `assertEq(alu_src,          1)
        // `assertEq(alu_op,     `OP_ADD)
        // `assertEq(ext_op,           1)
        // `assertEq(mem_write,        1)
        // // `assertEq(mem_to_reg,       0)
        // `assertEq(is_jump,          0)
        // `assertEq(zero_branch,      0)
        // // `assertEq(need_zero,        0)
        // `assertEq(status_branch,    0)
        // // `assertEq(need_st_Z,         )
        // // `assertEq(pc_select,    0'b00)  // select offset

        // TODO:
        // balrn   0x17    rs, rd          if [z]=0, branch and link to rs, store return in rd (31 by default)
        // balrz   0x16    rs, rd          if [z]=1, ---^---
        // brn     0x15    rs              if [z]=0, branch to rs
        // brz     0x14    rs              if [z]=1, branch to rs
        // jalr    0x09    rs, rd          unconditional jump and link
        // jr      0x08    rs              unconditional jump
        // balmn   0x17    rt, imm(rs)     if [z]=0, branches to address in memory and links to rt(31)
        // balmz   0x16    rt, imm(rs)     if [z]=1, ---^---
        // beq     0x04    rs, rt, offset  if rs=rt, branch to offset
        // beqal   0x2C    rs, rt, offset  if rs=rt, branch to offset and link 31
        // bmn     0x15    imm(rs)         if [z]=0, branch to address in memory
        // bmz     0x14    imm(rs)         if [z]=1, branch to address in memory
        // bneal   0x2D    rs, rt, offset  if rs!=rt, branch to offset and link 31
        // jalm    0x13    rt, imm(rs)     jump to address in memory and link to rt(31)
        // jalpc   0x1F    rt, offset      jump to pc-relative address, and link to rt(31)
        // jm      0x12    imm(rs)         jump to address in memory
        // jpc     0x1E    offset          jump to pc-relative address
        // lw      0x23    rt, imm(rs)     load word at rs+imm into rt
        // baln    0x1B    target26        if [z]=0, branch to target and link 31
        // balz    0x1A    target26        if [z]=1, branch to target and link 31
        // bn      0x19    target26        if [z]=0, branch to target
        // bz      0x18    target26        if [z]=1, branch to target
        // jal     0x03    target26        jump and link 31


        `printResults

    end
endmodule
