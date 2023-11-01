module computer(
  input      clk,
  input      rst_n,
  
  input      start,
  output reg halt,
  
  output reg       we,
  input      [7:0] idata,
  output reg [7:0] odata,
  output reg [4:0] addr
);
  
  reg [4:0] pc;
  reg [7:0] accumulator; 
  
  reg [2:0] opcode;
  
  // Shift instruction fields
  reg shift_l;
  reg shift_a;
  reg [2:0] shift_amt;
  
  // Jump instruction fields
  reg jump_p;
  reg jump_n;
  reg [2:0] jump_amt;
  
  // Control flags
  reg flag_p;
  reg flag_n;
  
  reg [1:0] state;
  reg [1:0] next_state;
  
  // State transition control
  always @(posedge clk) begin
    if(!rst_n) begin
      state <= 2'b11;
    end
    else begin
      if(start && !halt) begin
        state <= next_state;
      end
      else begin
        state <= 2'b11;
      end
    end
  end
  
  // State operations: Fetch -> Decode -> Execute
  always @(state) begin
    we <= 0;
    
    case(state)
      // Fetch
      2'b00: begin
        addr <= pc;
        pc <= pc + 1;
      
        next_state <= 2'b01;
      end

      // Decode
      2'b01:  begin 
        opcode <= idata[7:5];
        
        case(idata[7:5])
          // AND
          3'b000: addr <= idata[4:0];
          // ADD
          3'b010: addr <= idata[4:0];
          // LD
          3'b100: addr <= idata[4:0];
          // ST
          3'b101: addr <= idata[4:0];
          // CMP
          3'b110: addr <= idata[4:0];
          
          default: begin
            addr <= addr;
          end
        endcase
        
        // Shift
        case(idata[7:5])
          3'b011: begin
            shift_l   <= idata[4];
            shift_a   <= idata[3];
            shift_amt <= idata[2:0];
          end
          
          default: begin
            shift_l   <= 0;
            shift_a   <= 0;
            shift_amt <= 3'b0;
          end
        endcase
        
        // Jump
        case(idata[7:5])
          3'b111: begin
            jump_n   <= idata[4];
            jump_p   <= idata[3];
            jump_amt <= idata[2:0];
          end
          
          default: begin
            jump_n   <= 0;
            jump_p   <= 0;
            jump_amt <= 3'b0;
          end
        endcase
        next_state <= 2'b10;
      end

      // Execute
      2'b10: begin      
        case (opcode)
          // AND
          3'b000: accumulator <= accumulator & idata;
          
          3'b001: accumulator <= ~accumulator;
          // ADD
          3'b010: accumulator <= accumulator + idata;
          
          // SHFT
          3'b011: begin
            case ({shift_l, shift_a})
              2'b00: accumulator <= accumulator >> shift_amt;
              2'b01: accumulator <= {accumulator[7], accumulator[6:0] >> shift_amt};
              2'b10: accumulator <= accumulator << shift_amt;
              2'b11: accumulator <= accumulator << shift_amt;
            endcase
          end
          
          // LD
          3'b100: accumulator <= idata;
            
          // ST
          3'b101: begin
            we <= 1; 
            odata <= accumulator;
          end
          
          // CMP
          3'b110: begin
            if(accumulator != idata) begin
                flag_p <= (accumulator > idata)? 1'b1: 1'b0;      
                flag_n <= (accumulator < idata)? 1'b1: 1'b0;
            end
            else begin
                flag_p <= 0;  
                flag_n <= 0;
            end
       
          end
          
          // JMP
          3'b111: begin
            if({jump_amt, jump_n, jump_p} == 5'b11111) begin
              halt <= 1;
            end
            else begin
              halt <= 0;
              
              if((flag_n == jump_n && flag_p == jump_p) || {jump_n, jump_p} == 2'b11) begin 
                pc <= pc + ({{3{jump_amt[2]}}, jump_amt[1:0]} << 1);
              end
              else begin
                pc <= pc;
              end
            end
            
          end
        endcase
        
        next_state <= 2'b00;
      end
      
      // Reset
      2'b11: begin
        pc <= 0;
        halt <= 0;
        flag_p <= 0;
        flag_n <= 0;

        next_state <= 2'b00;
      end

      default: next_state <= 2'b00;
    endcase
  end
  
endmodule
