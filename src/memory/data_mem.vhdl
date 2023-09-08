library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.init_mem.all;

entity data_mem is
    generic (
        INIT_MEM : T_MEM(0 to DATA_SIZE - 1)
    );
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        I_ADDR : in std_logic_vector(31 downto 0);
        I_DATA : in std_logic_vector(31 downto 0);
        I_RD_EN, I_WR_EN : in std_logic;
        O_DATA : out std_logic_vector(31 downto 0)
    );
end data_mem;

architecture behavioural of data_mem is
    signal L_RAM : T_Mem(0 to DATA_SIZE - 1) := INIT_MEM;
    signal L_RAM_ADDR : std_logic_vector(29 downto 0);
begin
    process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            if (I_RST = '1') then
                L_RAM <= ((others => (others => '0')));
            elsif (I_WR_EN = '1') then
                L_RAM(to_integer(unsigned(L_RAM_ADDR))) <= I_DATA;
            end if;
        end if;
    end process;
    L_RAM_ADDR <= I_ADDR(31 downto 2);

    O_DATA <= L_RAM(to_integer(unsigned(L_RAM_ADDR))) when (I_RD_EN = '1') else
        x"00000000";
end architecture;