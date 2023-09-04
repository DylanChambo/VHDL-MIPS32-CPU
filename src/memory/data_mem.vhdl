library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity data_mem is
    generic (
        ADDR_WIDTH : integer := 10
    );
    port (
        I_CLK : in std_logic;
        I_ADDR : in std_logic_vector(31 downto 0);
        I_DATA : in std_logic_vector(31 downto 0);
        I_RD_EN, I_WR_EN : in std_logic;
        O_DATA : out std_logic_vector(31 downto 0)
    );
end data_mem;

architecture behavioural of data_mem is
    type Mem is array (0 to (2 ** ADDR_WIDTH) - 1) of std_logic_vector (31 downto 0);
    signal L_RAM : Mem := ((others => (others => '0')));
    signal L_RAM_ADDR : std_logic_vector(ADDR_WIDTH - 1 downto 0);
begin
    process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            if (I_WR_EN = '1') then
                L_RAM(to_integer(unsigned(L_RAM_ADDR))) <= I_DATA;
            end if;
        end if;
    end process;
    L_RAM_ADDR <= I_ADDR(ADDR_WIDTH + 1 downto 2);

    O_DATA <= L_RAM(to_integer(unsigned(L_RAM_ADDR))) when (I_RD_EN = '1') else
        x"00000000";
end architecture;