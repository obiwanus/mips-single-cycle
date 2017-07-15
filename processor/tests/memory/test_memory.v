`timescale 1ns/1ns
`include "_assert.v"

module test_memory(clk);
    input clk;

    reg error = 0;
    reg write = 0;
    reg [31:0] addr_in = 0;
    reg [31:0] data_in = 0;
    wire [31:0] data_out;

    memory MUT(data_out, addr_in, data_in, write, clk);

    initial begin
        $readmemh("tests/memory/test_dmem.dat", MUT.bytes);

        // Test fetch
        addr_in = 0;
        #1;
        `assertEq(data_out, 32'h01000000)
        @(posedge clk);

        addr_in = 4;
        #1;
        `assertEq(data_out, 32'h04030201)
        @(posedge clk);

        // Test write
        addr_in = 8;
        data_in = 32'hF0C0D0E0;
        write = 1;
        @(posedge clk);
        write = 0;
        #1;
        `assertEq(data_out, 32'hF0C0D0E0)

        // Test unaligned read
        addr_in = 6;
        #1;
        `assertEq(data_out, 32'hD0E00403)

        `printResults

    end
endmodule
