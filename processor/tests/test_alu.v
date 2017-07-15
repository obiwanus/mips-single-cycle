`timescale 1ns/1ns
`include "_const.v"
`include "_assert.v"

module test_alu;

    reg error = 0;

    reg [31:0] a = 0, b = 0;
    reg [2:0] op = 0;
    reg [4:0] shamt = 0;
    wire [31:0] out;
    wire zout;

    alu MUT(out, zout, a, b, op, shamt);

    initial begin

        a = 1;
        b = 28;
        op = `OP_ADD;
        #1;
        `assertEq(out, 29)
        `assertEq(zout, 0)

        a = 1;
        b = 28;
        op = `OP_SUB;
        #1;
        `assertEq(out, -27)
        `assertEq(zout, 0)

        a = 32;
        b = 32;
        op = `OP_SUB;
        #1;
        `assertEq(out, 0)
        `assertEq(zout, 1)

        a = 32'b01110010;
        b = 32'b10100001;
        op = `OP_OR;
        #1;
        `assertEq(out, 32'b11110011)
        `assertEq(zout, 0)

        a = 32'b01110010;
        b = 32'b10100001;
        op = `OP_AND;
        #1;
        `assertEq(out, 32'b00100000)
        `assertEq(zout, 0)

        a = 6;
        b = 2;
        op = `OP_SLT;
        #1;
        `assertEq(out, 0)
        `assertEq(zout, 1)

        a = 23;
        b = 34;
        op = `OP_SLT;
        #1;
        `assertEq(out, 1)
        `assertEq(zout, 0)

        b = 23;
        shamt = 3;
        op = `OP_SLL;
        #1;
        `assertEq(out, 184)
        `assertEq(zout, 0)
        shamt = 0;

        `printResults

    end
endmodule
