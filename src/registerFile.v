module RegisterFile (
    input clk,
    input [4:0] read_reg1_addr,
    input [4:0] read_reg2_addr,
    input [4:0] write_reg_addr,
    input [63:0] write_data,
    input write_enable,
    output [63:0] read_data1,
    output [63:0] read_data2
);

reg [63:0] registers [0:31];

assign read_data1 = (read_reg1_addr == 0) ? 64'b0 : registers[read_reg1_addr];
assign read_data2 = (read_reg2_addr == 0) ? 64'b0 : registers[read_reg2_addr];

// Write Access
always @(posedge clk) 
begin
    if (write_enable && write_reg_addr != 0) 
    begin // Register 0 is hardwired to 0
        registers[write_reg_addr] <= write_data;
    end
end

endmodule