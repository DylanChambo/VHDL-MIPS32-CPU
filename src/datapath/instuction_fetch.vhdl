library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_fetch is
    generic (
        INIT_FILE : string := "program.hex"
    );
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        I_NEW_PC : in std_logic_vector(31 downto 0);
        I_BRANCH : in std_logic;
        I_IF_FLUSH : in std_logic;
        I_PC_WRITE : in std_logic;
        I_IF_ID_WRITE : in std_logic;
        O_INSTRUCTUION : out std_logic_vector(31 downto 0);
        O_NEXT_PC : out std_logic_vector(31 downto 0)
    );
end instruction_fetch;

architecture behavioural of instruction_fetch is
    signal L_PC : unsigned(31 downto 0) := (others => '0');
    signal L_NEXT_PC : unsigned(31 downto 0) := (others => '0');
    signal M_INSTRUCTUION : std_logic_vector(31 downto 0) := (others => '0');
begin
    instruction_memory : entity work.instruction_mem
        generic map(
            INIT_FILE => INIT_FILE
        )
        port map(
            I_PC => std_logic_vector(L_PC),
            O_INSTRUCTION => M_INSTRUCTUION
        );

    process (I_CLK)
    begin
        if rising_edge(I_CLK) then
            -- Update PC
            if I_RST = '1' then
                L_PC <= x"00000000";
            else
                if I_PC_WRITE = '1' then
                    L_PC <= L_NEXT_PC;
                end if;
            end if;

            -- Update the outputs
            if (I_IF_FLUSH = '1') then
                O_INSTRUCTUION <= (others => '0');
                O_NEXT_PC <= (others => '0');
            elsif (I_IF_ID_WRITE = '1') then
                O_INSTRUCTUION <= M_INSTRUCTUION;
                O_NEXT_PC <= std_logic_vector(L_NEXT_PC);
            end if;
        end if;

    end process;

    L_NEXT_PC <= L_PC + 4 when I_BRANCH = '0' else
        unsigned(I_NEW_PC);
end architecture;