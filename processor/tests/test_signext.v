`timescale 1ns/1ns
`include "_assert.v"

module test_signext;
    reg error = 0;
    wire [29:0] out30;
    wire [31:0] out32;
    reg [15:0] in;
    signext16_30 MUT1(out30, in);
    signext16_32 MUT2(out32, in);

    initial begin

        in = 16'd23;
        #1;
        `assertEq(out30, 30'd23)
        `assertEq(out32, 32'd23)

        in = -16'd23;
        #1;
        `assertEq(out30, -30'd23)
        `assertEq(out32, -32'd23)

        `printResults

    end
endmodule
