`include "_const.v"
`include "_assert.v"

module test_memset;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/processor/memset/memset_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.registers.registers[`REG_A0], 32'd8)
        `assertEq(CPU.registers.registers[`REG_A1], 32'hDEADBEEF)

        repeat(20) @(posedge CPU.clk);

        `assertEq(CPU.dmemory.bytes[8],  8'hef)
        `assertEq(CPU.dmemory.bytes[9],  8'hbe)
        `assertEq(CPU.dmemory.bytes[10], 8'had)
        `assertEq(CPU.dmemory.bytes[11], 8'hde)

        `assertEq(CPU.dmemory.bytes[12], 8'hef)
        `assertEq(CPU.dmemory.bytes[13], 8'hbe)
        `assertEq(CPU.dmemory.bytes[14], 8'had)
        `assertEq(CPU.dmemory.bytes[15], 8'hde)

        `assertEq(CPU.dmemory.bytes[16], 8'hef)
        `assertEq(CPU.dmemory.bytes[17], 8'hbe)
        `assertEq(CPU.dmemory.bytes[18], 8'had)
        `assertEq(CPU.dmemory.bytes[19], 8'hde)

        `assertEq(CPU.dmemory.bytes[20], 8'hef)
        `assertEq(CPU.dmemory.bytes[21], 8'hbe)
        `assertEq(CPU.dmemory.bytes[22], 8'had)
        `assertEq(CPU.dmemory.bytes[23], 8'hde)

        repeat(11) @(posedge CPU.clk);

        `assertEq(CPU.dmemory.bytes[24], 8'h00)
        `assertEq(CPU.dmemory.bytes[25], 8'h00)
        `assertEq(CPU.dmemory.bytes[26], 8'h00)
        `assertEq(CPU.dmemory.bytes[27], 8'h00)

        repeat(23) @(posedge CPU.clk);

        `assertEq(CPU.dmemory.bytes[28], 8'hff)
        `assertEq(CPU.dmemory.bytes[29], 8'h7f)
        `assertEq(CPU.dmemory.bytes[30], 8'h00)
        `assertEq(CPU.dmemory.bytes[31], 8'h00)

        `assertEq(CPU.dmemory.bytes[32], 8'hff)
        `assertEq(CPU.dmemory.bytes[33], 8'h7f)
        `assertEq(CPU.dmemory.bytes[34], 8'h00)
        `assertEq(CPU.dmemory.bytes[35], 8'h00)

        `assertEq(CPU.dmemory.bytes[36], 8'hff)
        `assertEq(CPU.dmemory.bytes[37], 8'h7f)
        `assertEq(CPU.dmemory.bytes[38], 8'h00)
        `assertEq(CPU.dmemory.bytes[39], 8'h00)

        `assertEq(CPU.dmemory.bytes[40], 8'hff)
        `assertEq(CPU.dmemory.bytes[41], 8'h7f)
        `assertEq(CPU.dmemory.bytes[42], 8'h00)
        `assertEq(CPU.dmemory.bytes[43], 8'h00)

        `printResults
    end

endmodule
