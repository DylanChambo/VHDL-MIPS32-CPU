library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use work.types.all;

entity ALU is
    port (
        I_A, I_B : in std_logic_vector(31 downto 0);
        I_Control : in ALUControl;
        O_Result : out std_logic_vector(31 downto 0);
        O_Zero : out std_logic
    );
end ALU;

architecture Behavioural of ALU is
    signal L_Result : std_logic_vector(31 downto 0);
begin
    process (I_A, I_B, I_Control)
    begin
        case I_Control is
            when ALU_ADD => L_Result <= I_A + I_B;
            when ALU_SUB => L_Result <= I_A - I_B;
            when ALU_AND => L_Result <= I_A and I_B;
            when ALU_OR => L_Result <= I_A or I_B;
            when ALU_SLT =>
                if (I_A < I_B) then
                    L_Result <= x"00000001";
                else
                    L_Result <= x"0000000";
                end if;
            when others => L_Result <= I_A + I_B;
        end case;
    end process;

    O_Zero <= '1' when L_Result = 0 else
        '0';
    O_Result <= L_Result;
end architecture;