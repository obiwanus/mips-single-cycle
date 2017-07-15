`include "_const.v"
`include "_assert.v"

module test_andi;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/andi/andi_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'hF0)
        `assertEq(CPU.registers.registers[`REG_S1], 32'h0F)
        `assertEq(CPU.registers.registers[`REG_S2], 32'hCC)
        `assertEq(CPU.registers.registers[`REG_S3], 32'hFFFFABCE)

        `assertEq(CPU.registers.registers[`REG_T0], 32'hF0)
        `assertEq(CPU.registers.registers[`REG_T1], 32'hC0)
        `assertEq(CPU.registers.registers[`REG_T2], 32'h0C)
        `assertEq(CPU.registers.registers[`REG_T3], 32'h04)
        `assertEq(CPU.registers.registers[`REG_T4], 32'hABC2)

        `printResults
    end

endmodule
