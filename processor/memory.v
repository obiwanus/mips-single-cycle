// Memory (256 x 4 x 8-bit bytes) address is 32 bits (used only 10), word is 32 bits
module memory(data_out, addr_in, data_in, write, clk);
    input write, clk;
    input [31:0] addr_in;
    input [31:0] data_in;
    output [31:0] data_out;

    reg [7:0] bytes [0:255*4];

    wire [9:0] addr;
    assign addr = addr_in[9:0];  // we use only 10 bits of address

    // Little endian
    assign data_out = {bytes[addr+3], bytes[addr+2], bytes[addr+1], bytes[addr]};

    always @(posedge clk) if (write) begin
        bytes[addr]   = data_in[7:0];
        bytes[addr+1] = data_in[15:8];
        bytes[addr+2] = data_in[23:16];
        bytes[addr+3] = data_in[31:24];
    end
endmodule

// Read-only memory
module rom(data_out, addr);
    input [31:0] addr;
    output [31:0] data_out;

    memory storage(data_out, addr, , , );  // acts as a combinational circuit
endmodule
