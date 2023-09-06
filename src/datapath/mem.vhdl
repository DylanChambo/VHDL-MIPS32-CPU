library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic
    );
end memory;

architecture behavioural of memory is
    signal L_ADDR : std_logic_vector(31 downto 0);
    signal L_DATA : std_logic_vector(31 downto 0);
    signal D_DATA : std_logic_vector(31 downto 0);
begin
    data_memory : entity work.data_mem
        port map(
            I_CLK => I_CLK,
            I_ADDR => L_ADDR,
            I_DATA => L_DATA,
            I_RD_EN => I_MEM_READ,
            I_WR_EN => I_MEM_WRITE,
            O_DATA : D_Data
        );
end architecture;