# Instruction Processor

## Overview

This project implements a simplified version of Instruction Processor in Verilog.

**Instruction Set Architecture (ISA) Overview for Instruction Processing**

This ISA is designed for a simplified 64-bit processor. It includes a limited set of instructions categorized for arithmetic, logic, data movement, and control flow.

**1. Features**

*   **Instruction Length:** Fixed 64-bit instruction length.
*   **Addressing:** The architecture employs register-direct, immediate, and memory addressing modes.
*   **General Purpose Registers:** 32 general-purpose registers (R0-R27), each 64-bit wide.
*   **Special Purpose Registers:** A set of 64-bit special registers:
*   **PC (Program Counter):** Holds the address of the current instruction.
*   **R-MEM (Memory Register):** A temporary register used for memory access.
*   **LR (Link Register):** Stores the return address for subroutine calls.
*   **FR (Flag Register):** Stores processor status flags.

**2. Instruction Categories**
   1.  **ALU Operations (Opcode Type: `000000`)**
        *   These instructions perform arithmetic and logical operations on registers.
        *   They always use two source registers and write the result to a destination register.
        *   Instructions: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`.
        *   Syntax : `COMMAND R1, R2, R3`,  for `NOT` Syntax : `NOT R1, R2`
   2.   **Shift Operations (Opcode Type: `000001`)**
        *   These instructions perform bitwise shift and rotation operations.
        *   They take one source register, a shift value (immediate), and write the result to destination register.
        *   Instructions: `SHL`, `SHR`, `ROL`, `ROR`
        *   Syntax : `COMMAND R1, #shift_value, R2`
   3.   **Memory Operations (Opcode Type: `000010`)**
        *   These instructions load data from memory into a register or store register data into memory.
        *   They use register indirect addressing using the memory address field from the instruction and can read or write memory.
        *   Instructions: `LOAD`, `STORE`
        *   `LOAD`: Load data from memory into a register. Syntax : `LOAD R1, [mem_address]`
        *   `STORE`: Store data from a register into memory. Syntax : `STORE R1, [mem_address]`
   4.    **Branch Operations (Opcode Type: `000011`)**
        *   These instructions conditionally modify the program counter based on flag values from a `CMP` operation.
        *   They take a target address as operand which is a 16-bit value, relative to the current instruction.
        *   Instructions: `BEQ`, `BNE`, `BLT`, `BGT`.
        *   Syntax : `COMMAND [mem_address]`
  5.   **Jump and Subroutine Operations (Opcode Type: `000100`)**
        *   These instructions alter the program counter for jumps, subroutine calls, and returns.
        *   They take a target address as operand which is a 16-bit value.
        *   Instructions: `JMP`, `CALL`, `RET`.
        *   `JMP` : Jump to address. Syntax : `JMP [mem_address]`
        *   `CALL` : Call subroutine (store return address in Link Register). Syntax : `CALL [mem_address]`
        *   `RET` : Return from subroutine (load return address from Link Register). Syntax : `RET`
   6.   **Comparison Operations (Opcode Type: `000101`)**
        *   These instructions compare two register values and set flag register flags.
        *   Instructions: `CMP`.
        *   Syntax : `CMP R1, R2`
   7.   **Immediate Operations (Opcode Type: `000110`)**
        *   These instructions load immediate values into registers.
        *   They take a source register and a 16-bit immediate value which is extended to 64 bit and written to register.
        *   Instructions: `MOVI`
        *   Syntax : `MOVI R1, #immediate_value`

**3. Instruction Format**

Each 64-bit instruction is divided into fields:

| Field         | Bits    | Description                                                              |
| ------------- | ------- | ------------------------------------------------------------------------ |
| Opcode Type   | 63:58   | Specifies instruction category (e.g. ALU, shift, branch, memory etc.)  |
| Opcode        | 57:52   | Specifies a specific operation within the category                        |
| Source 1 Reg  | 51:47   | Source 1 register address (5 bits)                                     |
| Source 2 Reg/Imm/Mem  |46:42| Source 2 register address (5 bits)/ immediate value (5 LSB bits)/ Unused for memory |
| Destination Reg | 41:37| Destination register address (5 bits) / Unused for memory and branch |
| Immediate/Memory address | 36:21 | Immediate value (16 bits) or Memory Address (16 bits) depending on the type of instruction. |
| Unused/Don't care | 20:0| Unused for some operations.  |

**4. Operand Types**

*   **Registers:**  Identified by `R0` to `R27` for general purpose, with encodings from 00000 to 11011. Special purpose registers such as PC, R-MEM, LR and FR also follow the register convention.
*   **Immediate Values:** Integer constant values which are specified with '#' prefix.  Encoded directly in the instruction (16 bits, can be extended to 64).
*   **Memory Addresses:** Integer constant values which are enclosed with "[ ]".  Encoded directly in the instruction (16 bits, can be extended to 64).

## ISA

Instruction types:

1.  **Arithmetic and Logical (ALU) Operations:**
    *   `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`
2.  **Shift Operations:**
    *   `SHL`, `SHR`, `ROL`, `ROR`
3.  **Memory Operations:**
    *   `LOAD`, `STORE`
4.  **Branch Operations:**
    *   `BEQ`, `BNE`, `BLT`, `BGT`
5.  **Jump and Subroutine Operations:**
    *   `JMP`, `CALL`, `RET`
6.  **Comparison Operations:**
    *   `CMP`
7.  **Immediate Operations:**
    *   `MOVI`

### Register Encoding

*   General Purpose Registers (R0-R27): 5-bit values from `00000` to `11011`
*   Special Purpose Registers:
    *   PC (Program Counter): `11100`
    *   R-MEM (Memory Register): `11101`
    *   LR (Link Register): `11110`
    *   FR (Flag Register): `11111`
