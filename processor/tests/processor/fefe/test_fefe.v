/*
* Tests the program fefe.mips, which
* puts 0xFEFE in the first 64 bytes in memory
*/
`include "_const.v"
`include "_assert.v"

module test_fefe;  // not covfefe
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/processor/fefe/fefe_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_S0], 32'hFEFEFEFE)
        `assertEq(CPU.registers.registers[`REG_S1], 32'd64)
        `assertEq(CPU.registers.registers[`REG_T0], 32'h0)

        repeat(32) @(posedge CPU.clk);

        `assertEq(CPU.dmemory.bytes[0], 8'hFE)
        `assertEq(CPU.dmemory.bytes[1], 8'hFE)
        `assertEq(CPU.dmemory.bytes[2], 8'hFE)
        `assertEq(CPU.dmemory.bytes[3], 8'hFE)

        `printResults
    end

endmodule
