`timescale 1ns/1ns
`include "_assert.v"

module test_registers(clk);
    input clk;

    reg error = 0;
    reg write = 0;
    reg [4:0] addr_a = 0, addr_b = 0, addr_in = 0;
    reg [31:0] data_in = 0;
    wire [31:0] data_a, data_b;

    register_file MUT(data_a, data_b, addr_a, addr_b, addr_in, data_in, write, clk);

    initial begin
        $readmemh("tests/registers/test_reg.dat", MUT.registers);

        // Test fetch
        addr_a = 0;
        addr_b = 0;
        #1;
        `assertEq(data_a, 0)
        `assertEq(data_b, 0)

        @(posedge clk);

        addr_a = 1;
        addr_b = 2;
        #1;
        `assertEq(data_a, 32'h14)
        `assertEq(data_b, 32'h40)

        @(posedge clk);

        addr_a = 6;
        addr_b = 9;
        #1;
        `assertEq(data_a, 32'h32)
        `assertEq(data_b, 32'h28)

        @(posedge clk);

        // Test not write
        addr_in = 6;
        data_in = 32'h13;
        write = 0;
        @(posedge clk);  // wait for the data NOT to be written
        addr_a = 6;
        #1;
        if (data_a === 32'h13) begin
            $display("Write unexpectedly happened");
            error = 1;
        end

        // Test write
        addr_in = 6;
        data_in = 32'h13;
        write = 1;
        @(posedge clk);  // wait for the data to be written
        addr_a = 6;
        #1;
        `assertEq(data_a, 32'h13)
        write = 0;

        // Test write to the zero register
        addr_in = 0;
        data_in = 32'hFE;
        write = 1;
        @(posedge clk);  // wait for the data to be written
        addr_a = 0;
        #1;
        `assertEq(data_a, 32'h00)
        write = 0;

        `printResults
    end
endmodule
