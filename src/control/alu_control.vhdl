library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity alu_control is
    port (
        I_ALU_OP : in std_logic_vector(1 downto 0);
        I_OPCODE : in std_logic_vector(5 downto 0);
        I_FUNC : in std_logic_vector(5 downto 0);
        O_ALU_CONTROL : out AluControl
    );
end alu_control;

architecture behavioural of alu_control is
    function toSixBit(opcode : integer) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(opcode, 6));
    end function;
begin
    -- TODO : Implement Unsigned ALU instructions
    process (I_ALU_OP, I_OPCODE, I_FUNC)
    begin
        case I_ALU_OP is
            when "00" => -- LW/SW
                O_ALU_CONTROL <= ALU_ADD;
            when "01" => -- BEQ
                O_ALU_CONTROL <= ALU_SUB;
            when "10" => -- R-type
                case I_FUNC is
                    when toSixBit(32) => O_ALU_CONTROL <= ALU_ADD; -- ADD
                    when toSixBit(34) => O_ALU_CONTROL <= ALU_SUB; -- SUB
                    when toSixBit(36) => O_ALU_CONTROL <= ALU_AND; -- AND
                    when toSixBit(37) => O_ALU_CONTROL <= ALU_OR; -- OR
                    when toSixBit(38) => O_ALU_CONTROL <= ALU_SLT; -- SLT
                    when others => O_ALU_CONTROL <= ALU_ADD;
                end case;
            when "11" => -- ADDI
                case I_OPCODE is
                    when toSixBit(8) => O_ALU_CONTROL <= ALU_ADD; -- ADDI
                    when toSixBit(12) => O_ALU_CONTROL <= ALU_AND; -- ANDI
                    when toSixBit(13) => O_ALU_CONTROL <= ALU_OR; -- ORI
                    when toSixBit(10) => O_ALU_CONTROL <= ALU_SLT; -- SLTI
                    when others => O_ALU_CONTROL <= ALU_ADD;
                end case;
            when others =>
                O_ALU_CONTROL <= ALU_ADD;
        end case;
    end process;

end architecture;