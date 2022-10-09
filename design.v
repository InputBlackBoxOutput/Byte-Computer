module top(	
    input clk, 
	
    output led0, 
	output led1, 
	output led2, 
	output led3, 
	output led4, 
	output led5, 
	output led6, 
	output led7,

	output lcol0, 
	output lcol1, 
	output lcol2, 
	output lcol3);

    reg [31:0]counter = 32'b0;
	reg [7:0]data = 8'b0;

    assign {led0, led1, led2, led3, led4, led5, led6, led7} = ~(data);
    assign {lcol0, lcol1, lcol2, lcol3} = ~(4'b0001);

    always@(posedge clk) begin
    	counter = counter + 1;    

		if(counter & 32'h0100_0000) begin 
			data = 8'hFF;
		end
		else begin
			data = 8'h00;
		end
    end

endmodule
