library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.init_mem.all;

entity instruction_mem is
    generic (
        INIT_MEM : T_MEM(0 to TEXT_SIZE - 1)
    );
    port (
        I_PC : in std_logic_vector(31 downto 0);
        O_INSTRUCTION : out std_logic_vector(31 downto 0)
    );
end instruction_mem;

architecture behavioural of instruction_mem is

    signal L_ROM_ADDR : std_logic_vector(29 downto 0);

    constant ROM_MEM : T_MEM(0 to TEXT_SIZE - 1) := INIT_MEM;
begin
    L_ROM_ADDR <= I_PC(31 downto 2);
    O_INSTRUCTION <= ROM_MEM(to_integer(unsigned(L_ROM_ADDR)));
end architecture;