library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;

use std.textio.all;
use std.env.finish;

entity tb_register_file is
end tb_register_file;

architecture sim of tb_register_file is
    constant clk_hz : integer := 1e9;
    constant clk_period : time := 1 sec / clk_hz;
    signal L_CLK : std_logic := '0';
    signal L_RST : std_logic := '0';

    signal L_WR_ADDR : std_logic_vector(4 downto 0);
    signal L_WR_DATA : std_logic_vector(31 downto 0);
    signal L_WR_EN : std_logic;
    signal L_RD_ADDR_1 : std_logic_vector(4 downto 0) := (others => '0');
    signal L_RD_ADDR_2 : std_logic_vector(4 downto 0) := (others => '0');
    signal D_RD_DATA_1 : std_logic_vector(31 downto 0);
    signal D_RD_DATA_2 : std_logic_vector(31 downto 0);
begin
    L_CLK <= not L_CLK after clk_period / 2;

    DUT : entity work.register_file
        port map(L_CLK, L_RST, L_WR_ADDR, L_WR_DATA, L_WR_EN, L_RD_ADDR_1, L_RD_ADDR_2, D_RD_DATA_1, D_RD_DATA_2);

    SEQUENCER_PROC : process
    begin
        L_WR_ADDR <= (others => '0');
        L_WR_DATA <= x"11111111";
        L_WR_EN <= '1';
        wait for clk_period;
        L_WR_EN <= '0';
        wait for clk_period;

        L_WR_ADDR <= "00001";
        L_WR_DATA <= x"22222222";
        L_WR_EN <= '1';
        wait for clk_period;
        L_WR_EN <= '0';
        wait for clk_period;

        L_WR_ADDR <= "00010";
        L_WR_DATA <= x"33333333";
        L_WR_EN <= '1';
        wait for clk_period;
        L_WR_EN <= '0';
        wait for clk_period;

        L_RD_ADDR_1 <= "00000";
        L_RD_ADDR_2 <= "00001";
        wait for clk_period/10;

        assert (D_RD_DATA_1 = x"00000000")
        report "INCORRECT Data at Reg $0"
            severity failure;

        assert (D_RD_DATA_2 = x"22222222")
        report "INCORRECT Data at Reg $\1"
            severity failure;

        L_RD_ADDR_1 <= "00010";
        wait for clk_period/10;

        assert (D_RD_DATA_1 = x"33333333")
        report "INCORRECT Data at Reg $0"
            severity failure;

        assert (D_RD_DATA_2 = x"22222222")
        report "INCORRECT Data at Reg $\1"
            severity failure;

        L_RD_ADDR_1 <= "00001";
        L_RD_ADDR_2 <= "00000";
        wait for clk_period/10;

        assert (D_RD_DATA_1 = x"22222222")
        report "INCORRECT Data at Reg $0"
            severity failure;

        assert (D_RD_DATA_2 = x"00000000")
        report "INCORRECT Data at Reg $\1"
            severity failure;
    end process;

end architecture;