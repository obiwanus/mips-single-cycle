`include "_const.v"
`include "_assert.v"

module test_beq;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/beq/beq_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(6) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd1)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd2)
        `assertEq(CPU.registers.registers[`REG_T0], 32'd0)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd0)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd0)
        `assertEq(CPU.registers.registers[`REG_T3], 32'd5)

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd1)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd2)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd1)

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd2)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd4)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd2)

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd3)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd6)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd3)

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd4)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd8)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd4)

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_T0], 32'd5)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd10)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd5)

        repeat(5) @(posedge CPU.clk);

        // Should be unchanged since the loop is over
        `assertEq(CPU.registers.registers[`REG_T0], 32'd5)
        `assertEq(CPU.registers.registers[`REG_T1], 32'd10)
        `assertEq(CPU.registers.registers[`REG_T2], 32'd5)

        `assertEq(CPU.registers.registers[`REG_S2], 32'd398)

        `printResults
    end

endmodule
