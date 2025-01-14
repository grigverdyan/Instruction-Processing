module ControlUnit (
    input clk,
    input [63:0] instruction,
	output instruction_mem_read_enable,
    output [15:0] instruction_mem_addr,
	output reg_read_enable,
	output [4:0] read_reg1_addr,
	output [4:0] read_reg2_addr,
	output alu_enable,
    output [5:0] alu_op,
	output mem_read,
	output mem_write,
    output [15:0] mem_addr,
	output reg_write_enable,
	output [4:0] write_reg_addr,
	output reg_dest_sel,
	output [63:0] mem_write_data,
	output special_reg_write_enable,
	output [2:0] special_reg_write_addr,
	output [63:0] special_reg_write_data,
    output reg flag_set,
    input reset
);
	
//Internal Registers
reg [63:0] current_instruction;
reg [15:0] program_counter;

//Instruction Decode
wire [5:0] opcode_type;
wire [5:0] opcode;
wire [4:0] read_reg1;
wire [4:0] read_reg2;
wire [4:0] write_reg;
wire [15:0] immediate;
wire [15:0] mem_addr_decoder;
wire [1:0] source2_type;
wire [1:0] imm_type;
wire reg_dest_sel_decoder;

//ALU Flags
wire zero_flag;
wire sign_flag;
wire overflow_flag;
  
//Signals for read/write from register file
assign read_reg1_addr = read_reg1;
assign read_reg2_addr = read_reg2;
assign write_reg_addr = write_reg;

// Instruction Decoder Instance
InstructionDecoder instructionDecoder_inst (
    .instruction(current_instruction),
    .opcode_type(opcode_type),
    .opcode(opcode),
    .reg_dest_sel(reg_dest_sel_decoder),
    .reg_mem_dest(),
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .write_reg(write_reg),
    .immediate(immediate),
    .mem_addr(mem_addr_decoder),
    .source2_type(source2_type),
    .imm_type(imm_type),
    .flag_set(flag_set)
);
  
// Assign control signals
assign instruction_mem_read_enable = 1'b1;
assign instruction_mem_addr = program_counter[15:0];
assign reg_read_enable = 1'b1;

//Assign memory operations
assign mem_addr = mem_addr_decoder;

assign mem_write = (opcode_type == 6'b000010 && opcode == 6'b000010 ) ? 1'b1: 1'b0;
assign mem_read = (opcode_type == 6'b000010 && opcode == 6'b000001 ) ? 1'b1: 1'b0;

//Assign ALU Operations
assign alu_op = opcode;
assign alu_enable = ((opcode_type == 6'b000000 || opcode_type == 6'b000001 || opcode_type == 6'b000101) ) ? 1'b1: 1'b0;


//Control Register Write
assign reg_write_enable = reg_dest_sel_decoder;
assign reg_dest_sel = reg_dest_sel_decoder;

// Special Register write assign
assign special_reg_write_enable = (opcode_type == 6'b000100) ? 1'b1: 1'b0;

// Instruction fetch and increment PC
always @(posedge clk) 
begin
if(reset) 
    begin
        program_counter <= 16'b0;
        current_instruction <= 64'b0;
    end
else 
    begin
        current_instruction <= instruction;
        if (alu_enable || mem_write || mem_read || (opcode_type == 6'b000101) ||(opcode_type == 6'b000110) )
            program_counter <= program_counter + 1;
    end
end
  
//Assign data for memory write
assign mem_write_data = (write_reg == 5'b0) ? 64'b0 : ( (alu_enable || (opcode_type == 6'b000110)) ? alu_result : reg_read_data1);
	
// Assign special register control
always @(*) 
begin
if (opcode_type == 6'b000100) 
begin //Jump
    if (opcode == 6'b000001) 
    begin  // JMP
        special_reg_write_addr = 3'b000;
        special_reg_write_data = {mem_addr_decoder, {48{1'b0}}};
    end
    else if(opcode == 6'b000010)
    begin //CALL
        special_reg_write_addr = 3'b001;
        special_reg_write_data = {program_counter+1,{48{1'b0}}};
    end
    else if(opcode == 6'b000011) 
    begin // RET
        special_reg_write_addr = 3'b000;
        special_reg_write_data = special_reg_read_data;
    end
    else begin
        special_reg_write_addr = 3'b000;
        special_reg_write_data = 64'b0;
    end
end
else
begin
    special_reg_write_addr = 3'b000;
    special_reg_write_data = 64'b0;
end
end
	
	
//Assign ALU Flags
always @(*)
begin
    if (flag_set)
        special_reg_write_data = {sign_flag,zero_flag,overflow_flag,{61{1'b0}}};
    else
        special_reg_write_data = 64'b0;
end
  
endmodule