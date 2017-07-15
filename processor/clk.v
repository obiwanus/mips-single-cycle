`timescale 1ns/1ns

module clock_generator(clk);
    parameter frequency = 10;
    output reg clk;

    initial clk = 0;

    always begin
        #frequency clk = ~clk;
    end
endmodule
