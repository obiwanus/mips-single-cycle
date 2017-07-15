`include "_const.v"
`include "_assert.v"

module test_slt;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/slt/slt_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(8) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd10)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd374)
        `assertEq(CPU.registers.registers[`REG_S2], -32'd34)

        `assertEq(CPU.registers.registers[`REG_T0], 32'b1)
        `assertEq(CPU.registers.registers[`REG_T1], 32'b0)
        `assertEq(CPU.registers.registers[`REG_T2], 32'b0)
        `assertEq(CPU.registers.registers[`REG_T3], 32'b0)
        `assertEq(CPU.registers.registers[`REG_T4], 32'b1)

        `printResults
    end

endmodule
