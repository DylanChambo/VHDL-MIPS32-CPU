library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_decode is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        I_REG_WRITE : in std_logic;
        I_INSTRUCTION : in std_logic_vector(31 downto 0);
        I_NEXT_PC : in std_logic_vector(31 downto 0);
        I_WR_ADDR : in std_logic_vector(4 downto 0);
        I_WR_DATA : in std_logic_vector(31 downto 0);
        O_RD_DATA_1 : out std_logic_vector(31 downto 0);
        O_RD_DATA_2 : out std_logic_vector(31 downto 0);
        O_REG_RS : out std_logic_vector(4 downto 0);
        O_REG_RT : out std_logic_vector(4 downto 0);
        O_REG_RD : out std_logic_vector(4 downto 0);
        O_IMMIDIATE : out std_logic_vector(31 downto 0);
        O_NEXT_PC : out std_logic_vector(31 downto 0);
        O_REG_EQ : out std_logic
    );
end instruction_decode;

architecture behavioural of instruction_decode is
    signal L_REG_RS : std_logic_vector(4 downto 0);
    signal L_REG_RT : std_logic_vector(4 downto 0);
    signal L_REG_RD : std_logic_vector(4 downto 0);
    signal L_IMMIDIATE : std_logic_vector(31 downto 0);

    signal R_RD_DATA_1 : std_logic_vector(31 downto 0);
    signal R_RD_DATA_2 : std_logic_vector(31 downto 0);

begin
    register_file : entity work.register_file
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST,
            I_WR_ADDR => I_WR_ADDR,
            I_WR_DATA => I_WR_DATA,
            I_WR_EN => I_REG_WRITE,
            I_RD_ADDR_1 => L_REG_RS,
            I_RD_ADDR_2 => L_REG_RT,
            O_RD_DATA_1 => R_RD_DATA_1,
            O_RD_DATA_2 => R_RD_DATA_2
        );

    process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            O_RD_DATA_1 <= R_RD_DATA_1;
            O_RD_DATA_2 <= R_RD_DATA_2;

            O_IMMIDIATE <= L_IMMIDIATE;
            O_REG_RS <= L_REG_RS;
            O_REG_RT <= L_REG_RT;
            O_REG_RD <= L_REG_RD;
        end if;
    end process;

    O_NEXT_PC <= std_logic_vector(unsigned(I_NEXT_PC) + unsigned(L_IMMIDIATE & "00"));
    O_REG_EQ <= '1' when (R_RD_DATA_1 = R_RD_DATA_2) else
        '0';

    L_REG_RS <= I_INSTRUCTION(25 downto 21);
    L_REG_RT <= I_INSTRUCTION(20 downto 16);
    L_REG_RD <= I_INSTRUCTION(15 downto 11);

    L_IMMIDIATE <= x"1111" & I_INSTRUCTION(15 downto 0) when I_INSTRUCTION(15) = '1' else
        x"0000" & I_INSTRUCTION(15 downto 0);

end architecture;