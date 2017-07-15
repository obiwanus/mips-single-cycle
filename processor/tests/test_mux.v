`timescale 1ns/1ns
`include "_assert.v"

module test_mux;
    reg error = 0;
    wire [31:0] out_mux2, out_mux4;
    reg [31:0] a, b, c, d;
    reg select_mux2;
    reg [1:0] select_mux4;

    mux2 test_mux2(out_mux2, a, b, select_mux2);
    mux4 test_mux4(out_mux4, a, b, c, d, select_mux4);

    initial begin

        a = 1;
        b = 2;
        c = 3;
        d = 4;

        select_mux2 = 0;
        select_mux4 = 0;
        #1;
        `assertEq(out_mux2, a)
        `assertEq(out_mux4, a)

        select_mux2 = 1;
        select_mux4 = 1;
        #1;
        `assertEq(out_mux2, b)
        `assertEq(out_mux4, b)

        select_mux4 = 2'b10;
        #1;
        `assertEq(out_mux4, c)

        select_mux4 = 2'b11;
        #1;
        `assertEq(out_mux4, d)

        `printResults

    end
endmodule
