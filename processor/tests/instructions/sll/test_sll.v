`include "_const.v"
`include "_assert.v"

module test_sll;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/sll/sll_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(7) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'h1)
        `assertEq(CPU.registers.registers[`REG_S1], 32'h2)
        `assertEq(CPU.registers.registers[`REG_S2], 32'h3)

        `assertEq(CPU.registers.registers[`REG_T0], 32'h2)
        `assertEq(CPU.registers.registers[`REG_T1], 32'h4)
        `assertEq(CPU.registers.registers[`REG_T2], 32'h8)
        `assertEq(CPU.registers.registers[`REG_T3], 32'h18)

        `printResults
    end

endmodule
