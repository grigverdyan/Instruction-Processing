module InstructionMemory (
    input [15:0] addr,
    output [63:0] instruction
);

reg [63:0] rom [0:65535]; //2^16

initial begin
    $readmemh("instruction_memory.hex", rom); // Load instructions from file
end

assign instruction = rom[addr];

endmodule