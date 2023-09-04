library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package types is
    type ALUControl is (ALU_AND, ALU_OR, ALU_ADD, ALU_SUB, ALU_SLT);
end package types;