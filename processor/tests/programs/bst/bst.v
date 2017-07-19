`include "_const.v"
`include "_assert.v"

module test_bst;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/programs/bst/bst_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(1000) @(posedge CPU.clk);

        // `assertEq(CPU.dmemory.bytes[0], 8'h2)
        // `assertEq(CPU.dmemory.bytes[1], 8'h0)
        // `assertEq(CPU.dmemory.bytes[2], 8'h0)
        // `assertEq(CPU.dmemory.bytes[3], 8'h0)

        // `assertEq(CPU.dmemory.bytes[4], 8'hf6)
        // `assertEq(CPU.dmemory.bytes[5], 8'hff)
        // `assertEq(CPU.dmemory.bytes[6], 8'hff)
        // `assertEq(CPU.dmemory.bytes[7], 8'hff)

        // `assertEq(CPU.dmemory.bytes[8],  8'h9)
        // `assertEq(CPU.dmemory.bytes[9],  8'h0)
        // `assertEq(CPU.dmemory.bytes[10], 8'h0)
        // `assertEq(CPU.dmemory.bytes[11], 8'h0)

        // `assertEq(CPU.dmemory.bytes[12], 8'h3)
        // `assertEq(CPU.dmemory.bytes[13], 8'h0)
        // `assertEq(CPU.dmemory.bytes[14], 8'h0)
        // `assertEq(CPU.dmemory.bytes[15], 8'h0)

        // `assertEq(CPU.dmemory.bytes[16], 8'hf9)
        // `assertEq(CPU.dmemory.bytes[17], 8'hff)
        // `assertEq(CPU.dmemory.bytes[18], 8'hff)
        // `assertEq(CPU.dmemory.bytes[19], 8'hff)

        // `assertEq(CPU.dmemory.bytes[20], 8'h0)
        // `assertEq(CPU.dmemory.bytes[21], 8'h0)
        // `assertEq(CPU.dmemory.bytes[22], 8'h0)
        // `assertEq(CPU.dmemory.bytes[23], 8'h0)

        // `assertEq(CPU.dmemory.bytes[24], 8'h0c)
        // `assertEq(CPU.dmemory.bytes[25], 8'h00)
        // `assertEq(CPU.dmemory.bytes[26], 8'h00)
        // `assertEq(CPU.dmemory.bytes[27], 8'h00)

        // // Check min and max
        // `assertEq(CPU.registers.registers[`REG_S1], -32'd300)
        // `assertEq(CPU.registers.registers[`REG_S2], 32'd999)

        `assertEq(CPU.dmemory.bytes[0], 8'h2)
        `assertEq(CPU.dmemory.bytes[1], 8'h0)
        `assertEq(CPU.dmemory.bytes[2], 8'h0)
        `assertEq(CPU.dmemory.bytes[3], 8'h0)

        `assertEq(CPU.dmemory.bytes[4], 8'hf6)
        `assertEq(CPU.dmemory.bytes[5], 8'hff)
        `assertEq(CPU.dmemory.bytes[6], 8'hff)
        `assertEq(CPU.dmemory.bytes[7], 8'hff)

        `assertEq(CPU.dmemory.bytes[8],  8'h9)
        `assertEq(CPU.dmemory.bytes[9],  8'h0)
        `assertEq(CPU.dmemory.bytes[10], 8'h0)
        `assertEq(CPU.dmemory.bytes[11], 8'h0)


        // Check min and max
        `assertEq(CPU.registers.registers[`REG_S1], -32'd300)
        `assertEq(CPU.registers.registers[`REG_S2], 32'd999)

        `printResults
    end

endmodule
