`include "_const.v"
`include "_assert.v"

module test_sw;
    reg error = 0;
    processor CPU();

    initial begin
        $readmemb("tests/instructions/sw/sw_imem.dat", CPU.IFU.imemory.storage.bytes);

        repeat(9) @(posedge CPU.clk);

        `assertEq(CPU.dmemory.bytes[8],  8'd4)
        `assertEq(CPU.dmemory.bytes[9],  8'd0)
        `assertEq(CPU.dmemory.bytes[10], 8'd0)
        `assertEq(CPU.dmemory.bytes[11], 8'd0)

        `assertEq(CPU.dmemory.bytes[16], 8'hAA)
        `assertEq(CPU.dmemory.bytes[17], 8'hFF)
        `assertEq(CPU.dmemory.bytes[18], 8'hFF)
        `assertEq(CPU.dmemory.bytes[19], 8'hFF)

        `assertEq(CPU.dmemory.bytes[24], 8'hEF)
        `assertEq(CPU.dmemory.bytes[25], 8'hBE)
        `assertEq(CPU.dmemory.bytes[26], 8'hFF)
        `assertEq(CPU.dmemory.bytes[27], 8'hFF)


        `printResults
    end

endmodule
