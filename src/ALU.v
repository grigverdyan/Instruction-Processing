module ALU (
    input [5:0] alu_op,
    input [63:0] operand1,
    input [63:0] operand2,
	input [63:0] imm_val,
	input [1:0] imm_type,
    output reg [63:0] result,
	output reg zero_flag,
	output reg sign_flag,
	output reg overflow_flag
);
  
parameter   ADD = 6'b000001,
            SUB = 6'b000010,
            AND = 6'b000011,
            OR =  6'b000100,
            XOR = 6'b000101,
            NOT = 6'b000111;

parameter   SHL = 6'b000001,
            SHR = 6'b000010,
            ROL = 6'b000011,
            ROR = 6'b000100;

always @(*)
begin
  case(alu_op)
  
  //Arithmetic and logical operations
  ADD : result = operand1 + operand2;
  SUB : result = operand1 - operand2;
  AND : result = operand1 & operand2;
  OR : result = operand1 | operand2;
  XOR : result = operand1 ^ operand2;
  NOT : result = ~operand1;
  
  // Shift operations
  SHL : result = operand1 << imm_val[4:0];
  SHR : result = operand1 >> imm_val[4:0];
  SAR : result = $signed(operand1) >>> imm_val[4:0];
  ROL : result = {operand1 << imm_val[4:0] , operand1 >> (64 - imm_val[4:0]) };
  ROR : result = {operand1 >> imm_val[4:0] , operand1 << (64 - imm_val[4:0]) };
  
  default: result = 64'b0;
  endcase
  
  zero_flag = (result == 64'b0);
  sign_flag = result[63];
  overflow_flag = 1'b0;
end
endmodule