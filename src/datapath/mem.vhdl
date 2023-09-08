library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_stage is
    port (
        I_CLK : in std_logic;
        -- Execution Signals
        I_DATA : in std_logic_vector(31 downto 0);
        I_ALU_RESULT : in std_logic_vector(31 downto 0);
        I_DST_REG : in std_logic_vector(4 downto 0);
        -- Outputs
        O_RD_DATA : out std_logic_vector(31 downto 0);
        O_ALU_RESULT : out std_logic_vector(31 downto 0);
        O_DST_REG : out std_logic_vector(4 downto 0)
    );
end memory_stage;

architecture behavioural of memory_stage is
begin
    process (I_CLK)
    begin
        if rising_edge(I_CLK) then
            O_RD_DATA <= I_DATA;
            O_ALU_RESULT <= I_ALU_RESULT;
            O_DST_REG <= I_DST_REG;
        end if;
    end process;
end architecture;