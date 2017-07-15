`include "_const.v"
`include "_assert.v"

module test_jr;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/jr/jr_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd1)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd2)
        `assertEq(CPU.registers.registers[`REG_T0], 32'd0)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd0)

        repeat(3) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd1)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd2)

        repeat(3) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd2)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd4)

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd5)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd10)

        // the s-registers should be unchanged
        `assertEq(CPU.registers.registers[`REG_S0], 32'd1)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd2)

        `printResults
    end

endmodule
