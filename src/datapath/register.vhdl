library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity register_file is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        I_WR_ADDR : in std_logic_vector(4 downto 0);
        I_WR_DATA : in std_logic_vector(31 downto 0);
        I_WR_EN : in std_logic;
        I_RD_ADDR_1 : in std_logic_vector(4 downto 0);
        I_RD_ADDR_2 : in std_logic_vector(4 downto 0);
        O_RD_DATA_1 : out std_logic_vector(31 downto 0);
        O_RD_DATA_2 : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture behavioural of register_file is
    type T_Register is array (0 to 31) of std_logic_vector (31 downto 0);
    signal L_REG : T_Register := (others => (others => '0'));
begin
    process (I_CLK, I_RST)
    begin
        if (rising_edge(I_CLK)) then
            if (I_RST = '1') then
                L_REG <= (others => (others => '0'));
            else
                if (I_WR_EN = '1') then
                    L_REG(to_integer(unsigned(I_WR_ADDR))) <= I_WR_DATA;
                end if;
            end if;
        end if;
    end process;

    O_RD_DATA_1 <= x"00000000" when (I_RD_ADDR_1 = 0) else
        L_REG(to_integer(unsigned(I_RD_ADDR_1)));
    O_RD_DATA_2 <= x"00000000" when (I_RD_ADDR_2 = 0) else
        L_REG(to_integer(unsigned(I_RD_ADDR_2)));
end architecture;