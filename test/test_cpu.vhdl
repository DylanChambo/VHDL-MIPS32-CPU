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
    constant ADDR_WIDTH : integer := 10;
    type Mem is array (0 to (2 ** ADDR_WIDTH) - 1) of std_logic_vector (31 downto 0);

    signal L_CLK : std_logic := '0';
    signal L_RST : std_logic := '0';

begin
    DUT : entity work.cpu
        generic map(INIT_FILE => "test/programs/test2.hex")
        port map(L_CLK, L_RST);

    SEQUENCER_PROC : process
        alias INSTRUCTION : std_logic_vector(31 downto 0) is << signal DUT.D_INSTRUCTION : std_logic_vector(31 downto 0) >> ;
        alias LRAM : Mem is << signal DUT.datapath.memory.data_memory.L_RAM : Mem >> ;
    begin
        wait for clk_period; -- 1ns

        assert (INSTRUCTION = x"3408001e")
        report "INCORRECT INSTRUCTION"
            severity failure;

        wait for clk_period; -- 2ns

        assert (INSTRUCTION = x"34090014")
        report "INCORRECT INSTRUCTION"
            severity failure;

        wait for clk_period; -- 3ns

        assert (INSTRUCTION = x"01092020")
        report "INCORRECT INSTRUCTION"
            severity failure;

        wait for clk_period; -- 4ns

        assert (INSTRUCTION = x"AC040000")
        report "INCORRECT INSTRUCTION"
            severity failure;

        wait for clk_period; -- 5ns

        wait for clk_period; -- 6ns

        assert (LRAM(0) = x"00000000")
        report "RAM0 NOT ZERO"
            severity failure;

        wait for clk_period; -- 7ns

        assert (LRAM(0) = x"00000032")
        report "RAM0 NOT 50"
            severity failure;

        wait;
    end process;

    L_CLK <= not L_CLK after clk_period / 2;
end architecture;