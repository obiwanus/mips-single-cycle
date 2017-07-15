module mux2(out, a, b, select);
    parameter width = 32;
    output [width-1:0] out;
    input [width-1:0] a, b;
    input select;

    assign out = (select == 0) ? a : b;
endmodule

module mux4(out, a, b, c, d, select);
    parameter width = 32;
    output reg [width-1:0] out;
    input [width-1:0] a, b, c, d;
    input [1:0] select;

    always @(a or b or c or d or select) begin
        case (select)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
        endcase
    end
endmodule
