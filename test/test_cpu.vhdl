library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Types.all;

use std.textio.all;
use std.env.finish;

entity tb_cpu is
end tb_cpu;

architecture sim of tb_cpu is
    constant clk_hz : integer := 1e9;
    constant clk_period : time := 1 sec / clk_hz;

    signal L_CLK : std_logic := '0';
    signal L_RST : std_logic := '0';
begin
    DUT : entity work.cpu
        generic map(INIT_FILE => "test/programs/test2.hex")
        port map(L_CLK, L_RST);

    L_CLK <= not L_CLK after clk_period / 2;
end architecture;