// Test AND
`define MEMORY       "memory/and.hex"
`define MEMORY_CHECK "memory-check/and.hex"

// // Test NOT
// `define MEMORY       "memory/not.hex"
// `define MEMORY_CHECK "memory-check/not.hex"

// // Test ADD
// `define MEMORY       "memory/and.hex"
// `define MEMORY_CHECK "memory-check/and.hex"

// // Test SHFT
// `define MEMORY       "memory/shft.hex"
// `define MEMORY_CHECK "memory-check/shft.hex"

// // Test Unconditional JMP 
// `define MEMORY       "memory/unconditional-jmp.hex"
// `define MEMORY_CHECK "memory-check/unconditional-jmp.hex"

// // Test Conditional JMP
// `define MEMORY       "memory/conditional-jmp.hex"
// `define MEMORY_CHECK "memory-check/conditional-jmp.hex"

// // Test SUB
// `define MEMORY       "memory/sub.hex"
// `define MEMORY_CHECK "memory-check/sub.hex"

// // Test NOP
// `define MEMORY       "memory/nop.hex"
// `define MEMORY_CHECK "memory-check/nop.hex"

module computer_tb;
  reg clk;
  reg rst_n;
  
  reg start;
  wire halt;
  
  wire we;
  reg  [7:0] idata;
  wire [7:0] odata;
  wire [4:0] addr;
  
  computer dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
  
    .we(we),
    .halt(halt),
  
    .idata(idata),
    .odata(odata),
    .addr(addr)
  );

  initial begin
    $dumpfile("dump.vcd"); 
  end

  integer pass;
  reg [7:0]	memory [31:0];
  reg [7:0]	memory_check [31:0];
  initial begin
    $readmemh(`MEMORY, memory);
    $readmemh(`MEMORY_CHECK, memory_check);
  end
  
  always @(we, addr) begin
    if(we) begin
      memory[addr] <= odata;
    end
    else begin
      idata <= memory[addr];
    end
  end
    
  initial begin
    clk = 0;
  	forever #1 clk = ~clk;
  end

  integer i;
  initial begin
    start = 0;
    rst_n = 1;
    
    #1 rst_n = 0;
    #1 rst_n = 1;
    
    #4 start = 1;
    
    // Run the design
    #200;
    
    // Check
    pass = 1;
    for(i = 0; i < 32; i = i + 1) begin
      $display("%0d: %h", i, memory[i]);
      if(memory[i] != memory_check[i]) begin
        pass = 0;
      end
    end
    
    if(pass) begin
      $display("Test passed");
    end
    else begin
      $display("Test failed");
    end

    $finish();
  end
endmodule
