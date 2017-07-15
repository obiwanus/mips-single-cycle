`include "_const.v"
`include "_assert.v"

module test_sub;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/sub/sub_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(6) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd189)
        `assertEq(CPU.registers.registers[`REG_S1], -32'd28)

        `assertEq(CPU.registers.registers[`REG_T0], 32'd217)
        `assertEq(CPU.registers.registers[`REG_T1], -32'd245)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd0)
        `assertEq(CPU.registers.registers[`REG_T3], -32'd245)

        `printResults
    end

endmodule
