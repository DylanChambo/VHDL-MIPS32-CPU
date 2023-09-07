library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity main_control is
    port (
        I_INSTRUCTION : in std_logic_vector(31 downto 0);
        -- IF Signals
        O_IF_FLUSH : out std_logic;
        O_ID_FLUSH : out std_logic;
        O_EX_FLUSH : out std_logic;
        O_BRANCH : out std_logic;
        -- EX Signals
        O_REG_DST : out std_logic;
        O_ALU_OP : out std_logic_vector(1 downto 0);
        O_FUNC : out std_logic_vector(5 downto 0);
        O_OPCODE : out std_logic_vector(5 downto 0);
        O_ALU_SRC : out std_logic;
        -- MEM Signals
        O_MEM_RD : out std_logic;
        O_MEM_WR : out std_logic;
        -- WB Signals
        O_REG_WR : out std_logic;
        O_MEM_TO_REG : out std_logic
    );
end main_control;

architecture behavioural of main_control is
    function toOpCode(opcode : integer) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(opcode, 6));
    end function;
begin
    -- Generate control signals based on instruction
    process (I_INSTRUCTION)
    begin
        O_IF_FLUSH <= '0';
        O_ID_FLUSH <= '0';
        O_EX_FLUSH <= '0';
        O_BRANCH <= '0';
        O_REG_DST <= '0';
        O_ALU_SRC <= '0';
        O_MEM_RD <= '0';
        O_MEM_WR <= '0';
        O_REG_WR <= '0';
        O_MEM_TO_REG <= '0';
        O_ALU_OP <= "00";

        case (I_INSTRUCTION(31 downto 26)) is
            when toOpCode(0) => -- R-Type
                O_REG_DST <= '1';
                O_REG_WR <= '1';
                O_MEM_TO_REG <= '1';
                O_ALU_OP <= "10";
            when toOpCode(35) => -- lw
                O_ALU_SRC <= '1';
                O_MEM_RD <= '1';
                O_REG_WR <= '1';
            when toOpCode(43) => -- sw
                O_ALU_SRC <= '1';
                O_MEM_WR <= '1';
            when toOpCode(4) => -- beq
                O_BRANCH <= '1';
                O_ID_FLUSH <= '1';
            when toOpCode(8) => -- addi
                O_ALU_SRC <= '1';
                O_ALU_OP <= "11";
                O_MEM_TO_REG <= '1';
                O_REG_WR <= '1';
            when toOpCode(9) => -- addiu
                O_ALU_SRC <= '1';
                O_ALU_OP <= "11";
                O_MEM_TO_REG <= '1';
                O_REG_WR <= '1';
            when toOpCode(12) => -- andi
                O_ALU_SRC <= '1';
                O_ALU_OP <= "11";
                O_MEM_TO_REG <= '1';
                O_REG_WR <= '1';
            when toOpCode(13) => -- ori
                O_ALU_SRC <= '1';
                O_ALU_OP <= "11";
                O_MEM_TO_REG <= '1';
                O_REG_WR <= '1';
            when toOpCode(10) => -- slti
                O_ALU_SRC <= '1';
                O_ALU_OP <= "11";
                O_MEM_TO_REG <= '1';
                O_REG_WR <= '1';
            when toOpCode(11) => -- sltiu
                O_ALU_SRC <= '1';
                O_ALU_OP <= "11";
                O_MEM_TO_REG <= '1';
                O_REG_WR <= '1';
            when others =>
                O_ID_FLUSH <= '0';
        end case;

    end process;

    O_FUNC <= I_INSTRUCTION(5 downto 0);
    O_OPCODE <= I_INSTRUCTION(31 downto 26);
end architecture;