`include "_const.v"
`include "_assert.v"

module test_balrz;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/balrz/balrz_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(6) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd4)
        `assertEq(CPU.registers.registers[`REG_T0], 32'd0)

        repeat(8) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_A0], 32'd4)
        `assertEq(CPU.registers.registers[`REG_A1], 32'd2)

        repeat(9) @(posedge CPU.clk);

        // Should be unchanged since the branch was not taken
        `assertEq(CPU.registers.registers[`REG_A0], 32'd0)
        `assertEq(CPU.registers.registers[`REG_A1], 32'd2)


        `printResults
    end

endmodule
