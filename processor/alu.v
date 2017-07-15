`include "_const.v"

module alu(out, zout, a, b, op, shamt);
    input [31:0] a, b;
    input [2:0] op;
    input [4:0] shamt;
    output reg [31:0] out;
    output reg zout;

    reg [31:0] diff;

    always @(a or b or op or shamt) begin
        case (op)
            `OP_AND: out = a & b;
            `OP_OR:  out = a | b;
            `OP_NOR: out = ~(a | b);
            `OP_ADD: out = a + b;
            `OP_SUB: out = a + 1 + (~b);
            `OP_SLL: out = b << shamt;
            `OP_SRL: out = b >> shamt;
            `OP_SLT: begin
                        diff = a + 1 + (~b);
                        out = diff[31] ? 1 : 0;
                    end
            default: out = 32'bx;
        endcase
        zout = ~(|out);
    end
endmodule
