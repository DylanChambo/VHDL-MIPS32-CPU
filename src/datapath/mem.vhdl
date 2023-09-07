library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        -- Control Signals
        I_MEM_RD : in std_logic;
        I_MEM_WR : in std_logic;
        -- Execution Signals
        I_ALU_RESULT : in std_logic_vector(31 downto 0);
        I_WR_DATA : in std_logic_vector(31 downto 0);
        I_DST_REG : in std_logic_vector(4 downto 0);
        -- Outputs
        O_RD_DATA : out std_logic_vector(31 downto 0);
        O_ALU_RESULT : out std_logic_vector(31 downto 0);
        O_DST_REG : out std_logic_vector(4 downto 0)
    );
end memory;

architecture behavioural of memory is
    signal D_DATA : std_logic_vector(31 downto 0);
begin
    data_memory : entity work.data_mem
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST,
            I_ADDR => I_ALU_RESULT,
            I_DATA => I_WR_DATA,
            I_RD_EN => I_MEM_RD,
            I_WR_EN => I_MEM_WR,
            O_DATA => D_DATA
        );

    process (I_CLK)
    begin
        if rising_edge(I_CLK) then
            O_RD_DATA <= D_DATA;
            O_ALU_RESULT <= I_ALU_RESULT;
            O_DST_REG <= I_DST_REG;
        end if;
    end process;
end architecture;