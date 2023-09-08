library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

use work.init_mem.all;

entity tb_init_mem is
end tb_init_mem;

architecture sim of tb_init_mem is
    signal mem : T_MEMORY := init_memory("test/programs/test3.hex");

begin

end architecture;