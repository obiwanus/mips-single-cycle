// A 32-bit register file containing 32 registers
module register_file(data_a, data_b, addr_a, addr_b, addr_in, data_in, write, clk);
    input write, clk;
    input [4:0] addr_a, addr_b, addr_in;
    input [31:0] data_in;
    output [31:0] data_a, data_b;

    reg [31:0] registers [0:31];

    assign data_a = registers[addr_a];
    assign data_b = registers[addr_b];

    initial registers[5'b0] = 32'b0;  // hard-wired zero register

    always @(posedge clk) if (write && addr_in !== 0) registers[addr_in] = data_in;
endmodule
