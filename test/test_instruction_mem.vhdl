library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;

use work.Types.all;

use std.textio.all;
use std.env.finish;

entity tb_instruction_mem is
end tb_instruction_mem;

architecture sim of tb_instruction_mem is
    constant clk_hz : integer := 1e9;
    constant clk_period : time := 1 sec / clk_hz;
    signal clk : std_logic := '1';
    signal L_PC : std_logic_vector(31 downto 0) := (others => '0');
    signal D_INSTRUCTION : std_logic_vector(31 downto 0) := (others => '0');
begin
    DUT : entity work.instruction_mem
        generic map(INIT_FILE => "test/programs/test1.hex")
        port map(L_PC, D_INSTRUCTION);

    SEQUENCER_PROC : process
    begin
        L_PC <= (others => '0');
        wait for clk_period;

        assert (D_INSTRUCTION = x"FFFFFFFF")
        report "INCORRECT INSTRUCTION for PC = 0x0"
            severity failure;
        L_PC <= L_PC + x"00000004";
        wait for clk_period;

        assert (D_INSTRUCTION = x"00000000")
        report "INCORRECT INSTRUCTION for PC = 0x4"
            severity failure;

        L_PC <= L_PC + x"00000004";
        wait for clk_period;

        assert (D_INSTRUCTION = x"FFFFFFFF")
        report "INCORRECT INSTRUCTION for PC = 0x8"
            severity failure;

        L_PC <= L_PC + x"00000004";
        wait for clk_period;

        assert (D_INSTRUCTION = x"ABFF3210")
        report "INCORRECT INSTRUCTION for PC = 0xC"
            severity failure;

        L_PC <= L_PC + x"00000004";
        wait for clk_period;

        assert (D_INSTRUCTION = x"00000000")
        report "INCORRECT INSTRUCTION for PC = 0x10"
            severity failure;
    end process;

end architecture;