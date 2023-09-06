library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execution is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic
    );
end execution;

architecture behavioural of execution is
    signal L_ALU_A : std_logic_vector(31 downto 0);
    signal L_ALU_B : std_logic_vector(31 downto 0);
    signal ALU_RESULT : std_logic_vector(31 downto 0);
    signal ALU_ZERO : std_logic;
begin
    alu : entity work.alu
        port map(
            I_A => L_ALU_A
            I_B => L_ALU_B
            I_CONTROL => I_ALU_CONTROL
            O_RESULT => ALU_RESULT
            O_ZERO => ALU_ZERO
        );
end architecture;