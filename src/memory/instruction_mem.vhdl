library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
use work.types.all;

entity instruction_mem is
    generic (
        ADDR_WIDTH : integer := 8;
        INIT_FILE : string := "program.hex"
    );
    port (
        I_PC : in std_logic_vector(31 downto 0);
        O_INSTRUCTION : out std_logic_vector(31 downto 0)
    );
end instruction_mem;

architecture behavioural of instruction_mem is
    type ROM is array (0 to (2 ** ADDR_WIDTH) - 1) of std_logic_vector (31 downto 0);
    signal L_ROM_ADDR : std_logic_vector((ADDR_WIDTH - 1) downto 0);

    -- function to initialize memory content
    function init_memory(hex_file_name : in string) return ROM is
        file hex_file : text open read_mode is hex_file_name;
        variable hex_line : line;
        variable T_MEM : ROM := (others => (others => '0'));
    begin
        for i in ROM'range loop
            if endfile(hex_file) then
                exit;
            end if;
            readline(hex_file, hex_line);
            hread(hex_line, T_MEM(i));
        end loop;
        return T_MEM;
    end function;

    constant ROM_MEM : ROM := init_memory(INIT_FILE);
begin
    L_ROM_ADDR <= I_PC((ADDR_WIDTH + 1) downto 2);
    O_INSTRUCTION <= ROM_MEM(to_integer(unsigned(L_ROM_ADDR)));
end architecture;