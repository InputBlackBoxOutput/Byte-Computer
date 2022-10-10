`timescale 1ns/1ps
`include "designs/blinky.v"

module testbench;

    reg clk = 0;
    wire led0, led1, led2, led3, led4, led5, led6, led7;
    wire lcol0, lcol1, lcol2, lcol3;

    blinky b(
        .clk(clk),

        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3),
        .led4(led4),
        .led5(led5),
        .led6(led6),
        .led7(led7),

        .lcol0(lcol0),
        .lcol1(lcol1),
        .lcol2(lcol2),
        .lcol3(lcol3) 
    );

    always #0.01 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, b);    
    end

    initial begin
        #500 $finish();
    end

endmodule
