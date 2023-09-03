library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;

use work.Types.all;

use std.textio.all;
use std.env.finish;

entity tb_alu is
end tb_alu;

architecture sim of tb_alu is
    signal T_A, T_B : std_logic_vector(31 downto 0);
    signal T_Control : ALUControl;
    signal D_Result : std_logic_vector(31 downto 0);
    signal D_Zero : std_logic;
begin
    DUT : entity work.alu
        port map(T_A, T_B, T_Control, D_Result, D_Zero);

    SEQUENCER_PROC : process
    begin
        T_A <= CONV_STD_LOGIC_VECTOR(10, 32);
        T_B <= CONV_STD_LOGIC_VECTOR(10, 32);
        T_Control <= ALU_ADD;
        wait for 1 ns;

        assert (D_Result = CONV_STD_LOGIC_VECTOR(20, 32))
        report "Addition 1 failed"
            severity failure;

        T_A <= CONV_STD_LOGIC_VECTOR(15, 32);
        wait for 1 ns;

        assert (D_Result = CONV_STD_LOGIC_VECTOR(25, 32))
        report "Addition 2 failed"
            severity failure;
        T_Control <= ALU_SUB;
        wait for 1 ns;

        assert (D_Result = CONV_STD_LOGIC_VECTOR(5, 32))
        report "Subtraction 1 failed"
            severity failure;
    end process;

end architecture;