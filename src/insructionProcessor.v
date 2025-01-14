module InstructionProcessor (
    input clk,
    input reset,
    input [63:0] mem_data_in,
    output [63:0] mem_data_out,
	 output [15:0] mem_addr_out
);

//Internal Signals
wire [63:0] instruction;
wire [15:0] instruction_mem_addr;
wire instruction_mem_read_enable;
wire [63:0] reg_read_data1;
wire [63:0] reg_read_data2;
wire reg_read_enable;
wire [5:0] alu_op;
wire alu_enable;
wire [63:0] alu_result;
wire mem_read;
wire mem_write;
wire [15:0] mem_addr_decoder;
wire reg_write_enable;
wire [4:0] write_reg_addr;
wire reg_dest_sel;
wire [63:0] mem_write_data;
wire [63:0] special_reg_read_data;
wire special_reg_write_enable;
wire [2:0] special_reg_write_addr;
wire [63:0] special_reg_write_data;
wire [4:0] read_reg1_addr;
wire [4:0] read_reg2_addr;
wire flag_set;
wire [1:0] source2_type;
wire [15:0] immediate;

// Module Instantiations
InstructionMemory instructionMemory_inst (
	.addr(instruction_mem_addr),
	.instruction(instruction)
);
	
DataMemory dataMemory_inst (
	.clk(clk),
	.addr(mem_addr_decoder),
	.data_in(mem_write_data),
	.mem_write(mem_write),
	.data_out(mem_data_out)
);
	
RegisterFile registerFile_inst (
    .clk(clk),
    .read_reg1_addr(read_reg1_addr),
    .read_reg2_addr(read_reg2_addr),
    .write_reg_addr(write_reg_addr),
    .write_data(alu_result),
    .write_enable(reg_write_enable),
    .read_data1(reg_read_data1),
    .read_data2(reg_read_data2)
);

SpecialRegFile specialRegFile_inst (
    .clk(clk),
    .write_reg_addr(special_reg_write_addr),
    .write_data(special_reg_write_data),
    .write_enable(special_reg_write_enable),
	 .read_reg_addr(special_reg_write_addr),
	 .read_data(special_reg_read_data),
    .PC()
);
	
ALU alu_inst (
	.alu_op(alu_op),
	.operand1(reg_read_data1),
	.operand2( (source2_type == 2'b00)? reg_read_data2 : (source2_type == 2'b10)? {48'b0, immediate} : (mem_read) ? mem_data_in: 64'b0),
	.imm_val({48'b0,immediate}),
	.imm_type(),
	.result(alu_result),
	.zero_flag(),
	.sign_flag(),
	.overflow_flag()
);

ControlUnit controlUnit_inst (
    .clk(clk),
    .instruction(instruction),
	.instruction_mem_read_enable(instruction_mem_read_enable),
	.instruction_mem_addr(instruction_mem_addr),
	.reg_read_enable(reg_read_enable),
	.read_reg1_addr(read_reg1_addr),
	.read_reg2_addr(read_reg2_addr),
    .alu_enable(alu_enable),
    .alu_op(alu_op),
	.mem_read(mem_read),
	.mem_write(mem_write),
    .mem_addr(mem_addr_decoder),
	.reg_write_enable(reg_write_enable),
	.write_reg_addr(write_reg_addr),
	.reg_dest_sel(reg_dest_sel),
	.mem_write_data(mem_write_data),
	.special_reg_write_enable(special_reg_write_enable),
	.special_reg_write_addr(special_reg_write_addr),
	.special_reg_write_data(special_reg_write_data),
    .flag_set(flag_set),
    .reset(reset)
);

assign mem_addr_out = mem_addr_decoder;

endmodule