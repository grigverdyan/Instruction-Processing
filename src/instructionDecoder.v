module InstructionDecoder (
    input [63:0] instruction,
    output [5:0] opcode_type,
    output [5:0] opcode,
	output reg_dest_sel,
	output reg_mem_dest,
    output [4:0] read_reg1,
    output [4:0] read_reg2,
    output [4:0] write_reg,
    output [15:0] immediate,
	output [15:0] mem_addr,
    output [1:0] source2_type,
	output [1:0] imm_type,
	output flag_set
);

assign opcode_type = instruction[63:58];
assign opcode = instruction[57:52];

// Decode instruction fields based on the opcode type
always @(*)
begin
  case(opcode_type)
    6'b000000: //ALU
    begin
      read_reg1 = instruction[51:47];
      read_reg2 = instruction[46:42];
      write_reg = instruction[41:37];
      reg_dest_sel = 1'b1;
      reg_mem_dest = 1'b1;
      immediate = 16'b0;
      mem_addr = 16'b0;
      source2_type = 2'b00;
      imm_type = 2'b00;
      flag_set = 1'b0;
    end
    6'b000001: //Shift
    begin
      read_reg1 = instruction[51:47];
      read_reg2 = 5'b0;
      write_reg = instruction[41:37];
      immediate = instruction[46:42];
      reg_dest_sel = 1'b1;
      reg_mem_dest = 1'b1;
      mem_addr = 16'b0;
      source2_type = 2'b10;
      imm_type = 2'b10;
      flag_set = 1'b0;
    end
    6'b000010: // Memory Operations
    begin
    if(opcode == 6'b000001) //Load instruction
    begin
      read_reg1 = instruction[51:47];
      read_reg2 = 5'b0;
      write_reg = instruction[41:37];
      immediate = 16'b0;
      mem_addr = instruction[36:21];
      reg_dest_sel = 1'b1;
      reg_mem_dest = 1'b1;
      source2_type = 2'b11;
      imm_type = 2'b00;
      flag_set = 1'b0;
    end
    else if (opcode == 6'b000010) // Store instruction
    begin
      read_reg1 = instruction[51:47];
      read_reg2 = 5'b0;
      write_reg = 5'b0;
      immediate = 16'b0;
      mem_addr = instruction[36:21];
      reg_dest_sel = 1'b0;
      reg_mem_dest = 1'b0;
      source2_type = 2'b00;
      imm_type = 2'b00;
      flag_set = 1'b0;
    end
    else
    begin
      read_reg1 = 5'b0;
      read_reg2 = 5'b0;
      write_reg = 5'b0;
      immediate = 16'b0;
      mem_addr = 16'b0;
      reg_dest_sel = 1'b0;
      reg_mem_dest = 1'b0;
      source2_type = 2'b00;
      imm_type = 2'b00;
      flag_set = 1'b0;
    end
    end
    6'b000011: // Branch Operations
    begin
      read_reg1 = 5'b0;
      read_reg2 = 5'b0;
      write_reg = 5'b0;
      immediate = 16'b0;
      mem_addr = instruction[36:21];
      reg_dest_sel = 1'b0;
      reg_mem_dest = 1'b0;
      source2_type = 2'b00;
      imm_type = 2'b00;
      flag_set = 1'b0;
    end
    6'b000100: //Jump
    begin
      read_reg1 = 5'b0;
      read_reg2 = 5'b0;
      write_reg = 5'b0;
      immediate = 16'b0;
      mem_addr = instruction[36:21];
      reg_dest_sel = 1'b0;
      reg_mem_dest = 1'b0;
      source2_type = 2'b00;
      imm_type = 2'b00;
      flag_set = 1'b0;
    end
   6'b000101: // Comparison
    begin
      read_reg1 = instruction[51:47];
      read_reg2 = instruction[46:42];
      write_reg = 5'b0;
      immediate = 16'b0;
      mem_addr = 16'b0;
      reg_dest_sel = 1'b0;
      reg_mem_dest = 1'b0;
      source2_type = 2'b00;
      imm_type = 2'b00;
      flag_set = 1'b1;
    end
    6'b000110: // Immediate
    begin
      read_reg1 = 5'b0;
      read_reg2 = 5'b0;
      write_reg = instruction[41:37];
      immediate = instruction[36:21];
      mem_addr = 16'b0;
      reg_dest_sel = 1'b1;
      reg_mem_dest = 1'b1;
      source2_type = 2'b10;
      imm_type = 2'b10;
      flag_set = 1'b0;
    end
    default:
      read_reg1 = 5'b0;
      read_reg2 = 5'b0;
      write_reg = 5'b0;
      immediate = 16'b0;
      mem_addr = 16'b0;
      reg_dest_sel = 1'b0;
      reg_mem_dest = 1'b0;
      source2_type = 2'b00;
      imm_type = 2'b00;
      flag_set = 1'b0;
  endcase
end
endmodule