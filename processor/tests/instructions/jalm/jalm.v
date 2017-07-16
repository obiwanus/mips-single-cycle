`include "_const.v"
`include "_assert.v"

module test_jalm;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/jalm/jalm_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(7) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'd4)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd12)
        `assertEq(CPU.dmemory.bytes[12], 8'd4)
        `assertEq(CPU.dmemory.bytes[13], 8'd0)
        `assertEq(CPU.dmemory.bytes[14], 8'd0)
        `assertEq(CPU.dmemory.bytes[15], 8'd0)

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_A0], 32'd4)
        `assertEq(CPU.registers.registers[`REG_A1], 32'd2)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd29)

        `printResults
    end

endmodule
