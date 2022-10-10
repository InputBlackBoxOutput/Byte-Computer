module counter (clk, led0, led1, led2, led3, led4, led5, led6, led7, lcol0, lcol1, lcol2, lcol3 );
    input clk;
    
    output led0;
    output led1;
    output led2;
    output led3;
    output led4;
    output led5;
    output led6;
    output led7;

    output lcol0;
    output lcol1;
    output lcol2;
    output lcol3;

    reg [31:0] counter = 32'b0;

    assign {led7, led6, led5, led4, led3, led2, led1, led0} = counter[31:23] ^ 8'hFF; 
    assign {lcol3, lcol2, lcol1, lcol0} = ~ 4'b1000;

    always @ (posedge clk) begin
        counter <= counter + 1;
    end

endmodule