module tt_um_wrapper_inputblackboxoutput (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


    // Set all bidirectional pins as outputs
    assign uio_oe = 8'b11111111;

    wire we;
    wire halt;
    wire [4:0] addr;
  
    computer c(
      .clk(clk),
      .rst_n(rst_n),

      .start(ena),
      .halt(halt),

      .we(we),
      .idata(ui_in),
      .odata(uo_out),
      .addr(addr)
    );
  
  
  assign uio_out = {we, halt, ena, addr};

endmodule
