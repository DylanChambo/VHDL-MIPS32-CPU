library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;

use work.Types.all;

use std.textio.all;
use std.env.finish;

entity tb_data_mem is
end tb_data_mem;

architecture sim of tb_data_mem is
    constant clk_hz : integer := 1e9;
    constant clk_period : time := 1 sec / clk_hz;
    signal L_CLK : std_logic := '0';
    signal L_RST : std_logic := '0';
    signal L_ADDR : std_logic_vector(31 downto 0) := (others => '0');
    signal L_DATA : std_logic_vector(31 downto 0) := (others => '0');
    signal L_RD_EN, L_WR_EN : std_logic := '0';
    signal D_DATA : std_logic_vector(31 downto 0);
begin
    L_CLK <= not L_CLK after clk_period / 2;

    DUT : entity work.data_mem
        port map(L_CLK, L_RST, L_ADDR, L_DATA, L_RD_EN, L_WR_EN, D_DATA);

    SEQUENCER_PROC : process
    begin
        L_ADDR <= (others => '0');
        L_DATA <= x"ABCDEF01";
        L_WR_EN <= '1';
        wait for clk_period;
        L_WR_EN <= '0';
        wait for clk_period;
        L_ADDR <= x"00000004";
        L_DATA <= x"F0F0F0F0";
        L_WR_EN <= '1';
        wait for clk_period;
        L_WR_EN <= '0';
        wait for clk_period;

        L_ADDR <= x"00000000";
        L_RD_EN <= '1';
        wait for clk_period/10;

        assert (D_DATA = x"ABCDEF01")
        report "INCORRECT Data at ADDR = 0x0"
            severity failure;

        L_RD_EN <= '0';
        wait for clk_period/10;

        assert (D_DATA = x"00000000")
        report "INCORRECT Data when RD_EN = '0'"
            severity failure;

        L_ADDR <= x"00000004";
        L_RD_EN <= '1';
        wait for clk_period/10;

        assert (D_DATA = x"F0F0F0F0")
        report "INCORRECT Data when ADDR = 0x4"
            severity failure;
    end process;

end architecture;