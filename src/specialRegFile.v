module SpecialRegFile (
    input clk,
    input [2:0] write_reg_addr,
    input [63:0] write_data,
    input write_enable,
	input [2:0] read_reg_addr,
	output [63:0] read_data,
	output [63:0] PC
);

// Special rgisters
reg [63:0] pc;          // Program Counter
reg [63:0] link_reg;    // Link Register
reg [63:0] mem_reg;     // Memory Register
reg [63:0] flag_reg;    // Flag Register

assign PC = pc;


// Register Write
always @(posedge clk)
begin
    if(write_enable)
    begin
        case (write_reg_addr)
            3'b000: pc <= write_data;
            3'b001: link_reg <= write_data;
            3'b010: mem_reg <= write_data;
            3'b011: flag_reg <= write_data;
            default: ;
        endcase
    end
end

assign read_data = (read_reg_addr == 3'b000) ? pc:
					(read_reg_addr == 3'b001) ? link_reg:
					(read_reg_addr == 3'b010) ? mem_reg:
					(read_reg_addr == 3'b011) ? flag_reg:
					64'b0;
endmodule