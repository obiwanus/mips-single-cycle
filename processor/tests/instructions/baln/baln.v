`include "_const.v"
`include "_assert.v"

module test_baln;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/baln/baln_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_A0], 32'd0)
        `assertEq(CPU.registers.registers[`REG_A1], 32'd2)
        `assertEq(CPU.registers.registers[`REG_T0], 32'd1)


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
