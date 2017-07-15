`include "_const.v"
`include "_assert.v"

module test_srl;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/srl/srl_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(7) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'h02)
        `assertEq(CPU.registers.registers[`REG_S1], 32'h10)
        `assertEq(CPU.registers.registers[`REG_S2], 32'h30)

        `assertEq(CPU.registers.registers[`REG_T0], 32'h1)
        `assertEq(CPU.registers.registers[`REG_T1], 32'h0)
        `assertEq(CPU.registers.registers[`REG_T2], 32'h4)
        `assertEq(CPU.registers.registers[`REG_T3], 32'h6)

        `printResults
    end

endmodule
