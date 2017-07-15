`timescale 1ns/1ns
`include "_assert.v"

module test_zeroext;
    reg error = 0;
    wire [31:0] out32;
    reg [15:0] in;
    zeroext16_32 MUT1(out32, in);

    initial begin

        in = 16'd23;
        #1;
        `assertEq(out32, 32'd23)

        in = -16'd23;
        #1;
        `assertEq(out32, 32'b1111111111101001)

        `printResults

    end
endmodule
