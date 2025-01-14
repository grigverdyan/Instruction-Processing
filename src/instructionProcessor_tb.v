`timescale 1ns / 1ps

module InstructionProcessor_tb;

  reg clk;
  reg reset;
  reg [63:0] mem_data_in;
  wire [63:0] mem_data_out;
  wire [15:0] mem_addr_out;

// Instantiate the unit under test (UUT)
InstructionProcessor uut (
    .clk(clk),
    .reset(reset),
    .mem_data_in(mem_data_in),
    .mem_data_out(mem_data_out),
    .mem_addr_out(mem_addr_out)
);

initial 
begin
    $dumpfile("wave.vcd");
    $dumpvars(0, InstructionProcessor_tb);
end

// Clock generation
initial 
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial 
begin
    reset = 1;
    mem_data_in = 64'b0;
    #10;
    reset = 0;
    #10;
    mem_data_in = 64'h1234567890ABCDEF; //Memory input
    #1000;
    $finish;
end

endmodule