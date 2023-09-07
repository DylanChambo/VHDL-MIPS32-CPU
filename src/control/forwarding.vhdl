library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
entity forwarding_unit is
    port (
        I_MEM_WB_REG_WRITE : in std_logic;
        I_MEM_WB_REG_RD : in std_logic_vector(4 downto 0);
        I_ID_EX_REG_RS : in std_logic_vector(4 downto 0);
        I_ID_EX_REG_RT : in std_logic_vector(4 downto 0);
        I_EX_MEM_REG_RD : in std_logic_vector(4 downto 0);
        O_FORWARD_A : out std_logic_vector(1 downto 0);
        O_FORWARD_B : out std_logic_vector(1 downto 0)
    );
end forwarding_unit;

architecture behavioural of forwarding_unit is

begin
    process (I_MEM_WB_REG_WRITE, I_MEM_WB_REG_RD, I_ID_EX_REG_RT, I_EX_MEM_REG_RD)
    begin
        O_FORWARD_A <= "00";
        O_FORWARD_B <= "00";

        if (I_MEM_WB_REG_WRITE = '1' and I_EX_MEM_REG_RD /= 0) then
            if (I_EX_MEM_REG_RD = I_ID_EX_REG_RS) then -- EX Stage forwarding
                O_FORWARD_A <= "01";
            elsif (I_MEM_WB_REG_RD = I_ID_EX_REG_RS) then -- Mem Stage forwarding
                O_FORWARD_A <= "10";
            end if;

            if (I_EX_MEM_REG_RD = I_ID_EX_REG_RT) then -- EX Stage forwarding
                O_FORWARD_B <= "01";
            elsif (I_MEM_WB_REG_RD = I_ID_EX_REG_RT) then -- Mem Stage forwarding
                O_FORWARD_B <= "10";
            end if;
        end if;
    end process;

end architecture;