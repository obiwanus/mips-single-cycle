`timescale 1ns/1ns
`include "_assert.v"

module test_ifu(input clk);

    // Outputs of IFU
    wire [31:0] instruction;
    wire branch_taken;
    wire [31:0] pc_seq;

    // Status signals
    reg [15:0] imm16 = 0;
    reg [25:0] addr26 = 0;
    reg [31:0] pc_reg = 0;
    reg [31:0] pc_mem = 0;
    reg zero = 0;
    reg st_Z = 0;

    // Control signals
    reg [1:0] pc_select;  // = 2'b00;
    reg is_jump;  // = 0;
    reg status_branch;  // = 0;
    reg need_st_Z;  // = 0;
    reg zero_branch;  // = 0;
    reg need_zero;  // = 0;

    reg error = 0;

    ifu MUT(instruction, branch_taken, pc_seq, imm16, addr26, pc_reg, pc_mem, zero, st_Z, pc_select,
            is_jump, status_branch, need_st_Z, zero_branch, need_zero, clk);

    localparam INSTR_0 = 32'b11001010000011110011001101010101;
    localparam INSTR_1 = 32'b00000000001100110000111111111111;
    localparam INSTR_2 = 32'b00100000000001000000000000001000;

    initial begin
        $readmemb("tests/ifu/test_imem.dat", MUT.imemory.storage.bytes);

        // Test sequential fetch
        status_branch = 0;
        zero_branch = 0;
        is_jump = 0;
        addr26 = 26'b111;

        @(posedge clk);
        `assertEq(instruction, INSTR_0)
        @(posedge clk);
        `assertEq(instruction, INSTR_1)
        @(posedge clk);
        `assertEq(instruction, INSTR_2)

        // Test jump
        is_jump = 1;
        addr26 = 26'h0;  // jump back to instruction 0
        pc_select = 2'b01;  // select jump
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_0)
        is_jump = 1;
        addr26 = 26'h2;  // jump to instruction 2
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_2)

        // Test zero branch
        pc_select = 2'b00;  // select branch
        is_jump = 0;
        zero_branch = 1;
        zero = 1;
        need_zero = 1;
        imm16 = -3;
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_0)
        zero = 0;
        #1;
        `assertEq(branch_taken, 0)
        @(posedge clk);
        `assertEq(instruction, INSTR_1)
        zero = 0;
        need_zero = 0;
        imm16 = -2;
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_0)
        zero_branch = 0;
        status_branch = 0;

        // Wait 2 more cycles - pc should be 2
        @(posedge clk);
        @(posedge clk);

        // Test status branch
        is_jump = 0;
        status_branch = 1;
        st_Z = 1;
        need_st_Z = 1;
        zero_branch = 0;
        zero = 0;
        imm16 = -3;
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_0)
        st_Z = 0;
        #1;
        `assertEq(branch_taken, 0)
        @(posedge clk);
        `assertEq(instruction, INSTR_1)
        st_Z = 0;
        imm16 = -2;
        need_st_Z = 0;
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_0)
        status_branch = 0;

        // Test register jump
        is_jump = 1;
        pc_reg = 8;
        pc_select = 0'b10;  // select register
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_2)

        // Test memory conditional jump
        is_jump = 0;
        zero_branch = 1;
        need_zero = 1;
        zero = 1;
        pc_mem = 0;
        pc_select = 0'b11;  // select memory
        #1;
        `assertEq(branch_taken, 1)
        @(posedge clk);
        `assertEq(instruction, INSTR_0)

        `printResults
    end
endmodule
