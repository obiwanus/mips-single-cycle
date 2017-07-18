module processor;
    wire clk;
    wire [4:0] reg_addr_in, reg_addr_dst;
    wire write, linked;
    wire [31:0] mem_addr;
    wire [31:0] data_a, data_b, data_bus, reg_data_in, sext_imm16, zext_imm16, ext_imm16;
    wire [31:0] instruction, mem_data;
    wire [31:0] pc_seq;
    wire branch_taken;

    // alu wires
    wire [31:0] alu_out, alu_in1, alu_in2;
    wire alu_zout;

    wire [4:0] rs, rt, rd;
    wire [4:0] shamt;
    wire [15:0] imm16;
    wire [25:0] addr26;

    // control wires
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

    reg st_Z = 0;

    reg [31:0] cycle_counter;

    clock_generator clk_gen(clk);
    register_file registers(data_a, data_b, rs, rt, reg_addr_dst, reg_data_in, write, clk);
    memory dmemory(mem_data, alu_out, data_b, mem_write, clk);
    control ctrl(instruction, reg_write, reg_dst, write_reg31, link, alu_src,
                 alu_op, ext_op, mem_write, mem_to_reg, is_jump, zero_branch,
                 need_zero, status_branch, need_st_Z, pc_select);
    alu ALU(alu_out, alu_zout, alu_in1, alu_in2, alu_op, shamt);
    ifu IFU(instruction, branch_taken, pc_seq, imm16, addr26, data_a, mem_data, alu_zout, st_Z,
            pc_select, is_jump, status_branch, need_st_Z, zero_branch, need_zero, clk);

    // split instruction into wires
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign shamt = instruction[10:6];
    assign imm16 = instruction[15:0];
    assign addr26 = instruction[25:0];

    assign alu_in1 = data_a;    // first input on alu is always from register
    mux2 alu_src_select(alu_in2, data_b, ext_imm16, alu_src);
    mux2 #(5) reg_addr_select(reg_addr_in, rd, rt, reg_dst);
    mux2 #(5) reg_dst_select(reg_addr_dst, reg_addr_in, 5'd31, write_reg31);
    mux2 #(32) reg_data_select(reg_data_in, data_bus, pc_seq, linked);

    mux2 extender(ext_imm16, zext_imm16, sext_imm16, ext_op);
    signext16_32 sext_imm(sext_imm16, imm16);
    zeroext16_32 zext_imm(zext_imm16, imm16);

    or(write, reg_write, linked);
    and(linked, link, branch_taken);
    mux2 reg_or_mem(data_bus, alu_out, mem_data, mem_to_reg);


    initial begin
        $readmemb("init/imem.dat", IFU.imemory.storage.bytes);
        $readmemh("init/reg.dat", registers.registers);
        $readmemh("init/dmem.dat", dmemory.bytes);
        cycle_counter = 0;
    end

    always @(negedge clk) begin
        st_Z = (alu_out == 0);
        cycle_counter = cycle_counter + 1;
    end

endmodule
