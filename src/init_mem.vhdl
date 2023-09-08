library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use IEEE.std_logic_textio.all;
use std.textio.all;

package init_mem is
    constant TEXT_SIZE : natural := 512;
    constant DATA_SIZE : natural := 1280;
    type T_MEM is array (natural range <>) of std_logic_vector (31 downto 0);

    type T_MEMORY is record
        text : T_MEM(0 to TEXT_SIZE - 1);
        data : T_MEM(0 to DATA_SIZE - 1);
    end record;

    -- function to initialize memory content
    function init_memory(hex_file_name : string := "program.hex") return T_MEMORY;
end package init_mem;

package body init_mem is
    function init_memory(hex_file_name : string := "program.hex") return T_MEMORY is
        file hex_file : text open read_mode is hex_file_name;
        variable hex_line : line;
        variable colon : character;
        variable hex_data_size : std_logic_vector(7 downto 0);
        variable hex_address : std_logic_vector(15 downto 0);
        variable hex_record_code : std_logic_vector(7 downto 0);
        variable hex_checksum_code : std_logic_vector(7 downto 0);
        variable sum : std_logic_vector(7 downto 0) := (others => '0');
        variable temp_byte : std_logic_vector(7 downto 0);
        variable offset : unsigned(15 downto 0) := (others => '0');
        variable T_MEM : T_MEMORY := (others => (others => (others => '0')));
    begin
        while (not endfile(hex_file)) loop
            readline(hex_file, hex_line);
            read(hex_line, colon);
            if (colon /= ':') then
                exit;
            end if;

            hread(hex_line, hex_data_size);
            report to_hstring(hex_data_size);

            hread(hex_line, hex_address);
            report to_hstring(hex_address);

            hread(hex_line, hex_record_code);
            report to_hstring(hex_record_code);

            sum := std_logic_vector(unsigned(hex_data_size) + unsigned(hex_address(7 downto 0)) + unsigned(hex_address(15 downto 8)) + unsigned(hex_record_code));
            if (hex_record_code = x"01") then
                exit;
            end if;

            for i in 0 to to_integer(unsigned(hex_data_size)) - 1 loop
                hread(hex_line, temp_byte);
                report to_hstring(temp_byte);
                sum := std_logic_vector(unsigned(sum) + unsigned(temp_byte));
                if (hex_address(15 downto 12) = x"0" or hex_address(15 downto 12) = x"8") -- text
                    then
                    offset := (others => '0') when hex_address(15 downto 12) = x"0" else
                        x"0100";
                    T_MEM.text(to_integer(unsigned(hex_address) + offset) + (i/4))((3 - (i mod 4)) * 8 + 7 downto 8 * (3 - (i mod 4))) := temp_byte;
                else -- data
                    offset := x"0500" when hex_address(15 downto 12) = x"9" else
                        x"0100" when hex_address(15 downto 12) = x"2" else
                        (others => '0');
                    T_MEM.text(to_integer(unsigned(hex_address) + offset) + (i/4))((3 - (i mod 4)) * 8 + 7 downto 8 * (3 - (i mod 4))) := temp_byte;
                end if;
            end loop;

            hread(hex_line, hex_checksum_code);
            report to_hstring(hex_checksum_code);

            assert(unsigned(hex_checksum_code) = unsigned(not sum) + x"01")
            report "Checksum error: " & to_hstring(hex_checksum_code) & " != " & to_hstring(unsigned(not sum) + x"01") severity error;
            if (unsigned(hex_checksum_code) /= unsigned(not sum) + x"01") then
                exit;
            end if;

        end loop;
        return T_MEM;
    end function;
end package body init_mem;