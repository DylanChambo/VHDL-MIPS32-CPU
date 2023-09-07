library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_detection_unit is
    port (
        I_MEM_READ : in std_logic;
        I_INSTUCTION : in std_logic_vector(31 downto 0);
        I_REG_RT : in std_logic_vector(4 downto 0);
        O_FLUSH : out std_logic;
        O_IF_ID_WRITE : out std_logic;
        O_PC_WRITE : out std_logic
    );
end hazard_detection_unit;

architecture behavioural of hazard_detection_unit is

begin

    process (I_MEM_READ, I_INSTUCTION, I_REG_RT)
    begin
        O_IF_ID_WRITE <= '1';
        O_PC_WRITE <= '1';
        O_FLUSH <= '0';
        if (I_MEM_READ = '1' and ((I_REG_RT = I_INSTUCTION(25 downto 21)) or I_REG_RT = I_INSTUCTION(10 downto 16))) then
            O_FLUSH <= '1';
            O_IF_ID_WRITE <= '0';
            O_PC_WRITE <= '1';
        end if;
    end process;

end architecture;