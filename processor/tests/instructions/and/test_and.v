`include "_const.v"
`include "_assert.v"

module test_and;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/and/and_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'hF0)
        `assertEq(CPU.registers.registers[`REG_S1], 32'h0F)
        `assertEq(CPU.registers.registers[`REG_S2], 32'hCE)
        `assertEq(CPU.registers.registers[`REG_S3], 32'h00)
        `assertEq(CPU.registers.registers[`REG_S4], 32'hFF)

        `assertEq(CPU.registers.registers[`REG_T0], 32'h00)
        `assertEq(CPU.registers.registers[`REG_T1], 32'hC0)
        `assertEq(CPU.registers.registers[`REG_T2], 32'h00)
        `assertEq(CPU.registers.registers[`REG_T3], 32'hCE)

        `printResults
    end

endmodule
