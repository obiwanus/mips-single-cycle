`include "_const.v"
`include "_assert.v"

module test_jalr;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/jalr/jalr_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(5) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd4)

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_A0], 32'd4)
        `assertEq(CPU.registers.registers[`REG_A1], 32'd2)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd29)

        `printResults
    end

endmodule
