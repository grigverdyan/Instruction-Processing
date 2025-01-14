module DataMemory (
    input clk,
    input [15:0] addr,
    input [63:0] data_in,
    input mem_write,
    output [63:0] data_out
);

reg [63:0] ram [0:65535];

assign data_out = ram[addr];

always @(posedge clk)
begin
  if (mem_write)
  begin
    ram[addr] <= data_in;
  end
end
endmodule