`include "_const.v"
`include "_assert.v"

module test_bst;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/programs/bst/bst_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(1120) @(posedge CPU.clk);

        // Check min and max
        `assertEq(CPU.dmemory.bytes[500], 8'hd4)
        `assertEq(CPU.dmemory.bytes[501], 8'hfe)
        `assertEq(CPU.dmemory.bytes[502], 8'hff)
        `assertEq(CPU.dmemory.bytes[503], 8'hff)

        `assertEq(CPU.dmemory.bytes[512], 8'he7)
        `assertEq(CPU.dmemory.bytes[513], 8'h03)
        `assertEq(CPU.dmemory.bytes[514], 8'h0)
        `assertEq(CPU.dmemory.bytes[515], 8'h0)


        // Check sorted list
        `assertEq(CPU.dmemory.debug_words[0], -32'd300)
        `assertEq(CPU.dmemory.debug_words[1], -32'd10)
        `assertEq(CPU.dmemory.debug_words[2], -32'd7)
        `assertEq(CPU.dmemory.debug_words[3], 32'd0)
        `assertEq(CPU.dmemory.debug_words[4], 32'd2)
        `assertEq(CPU.dmemory.debug_words[5], 32'd3)
        `assertEq(CPU.dmemory.debug_words[6], 32'd9)
        `assertEq(CPU.dmemory.debug_words[7], 32'd12)
        `assertEq(CPU.dmemory.debug_words[8], 32'd18)
        `assertEq(CPU.dmemory.debug_words[9], 32'd999)

        `printResults
    end

endmodule
