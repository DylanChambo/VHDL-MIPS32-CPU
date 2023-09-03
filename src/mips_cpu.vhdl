library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic
    );
end cpu;

architecture behavioural of cpu is
    signal L_PC : unsigned(7 downto 0);
begin
    -- Instantiate the components
    control_unit : entity work.control_unit
        port map();

    datapath : entity work.datapath
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST

        );

end architecture;