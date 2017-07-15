module zeroext16_32(out, in);
    output [31:0] out;
    input [15:0] in;
    assign out = {16'b0, in};
endmodule
