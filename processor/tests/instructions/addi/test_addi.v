`include "_const.v"
`include "_assert.v"

module test_addi;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/addi/addi_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(4) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd0)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd3)
        `assertEq(CPU.registers.registers[`REG_T0], 32'd255)
        `assertEq(CPU.registers.registers[`REG_T1], -32'd3)

        `printResults
    end

endmodule
