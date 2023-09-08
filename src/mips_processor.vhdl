library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity mips_processor is
    generic (INIT_FILE : string := "program.hex");
    port (
        I_CLK : in std_logic;
        I_RST_N : in std_logic
    );
end mips_processor;
architecture behavioural of mips_processor is
    signal L_RST : std_logic;

    signal M_INSTRUCTION : std_logic_vector(31 downto 0);
    signal M_DATA : std_logic_vector(31 downto 0);

    signal C_PC : std_logic_vector(31 downto 0);
    signal C_MEM_ADDR : std_logic_vector(31 downto 0);
    signal C_MEM_DATA : std_logic_vector(31 downto 0);
    signal C_MEM_WR : std_logic;
    signal C_MEM_RD : std_logic;
begin
    -- Instantiate the components
    cpu : entity work.cpu
        port map(
            I_CLK => I_CLK,
            I_RST => L_RST,
            I_INSTRUCTION => M_INSTRUCTION,
            I_DATA => M_DATA,
            O_PC => C_PC,
            O_MEM_ADDR => C_MEM_ADDR,
            O_MEM_DATA => C_MEM_DATA,
            O_MEM_WR => C_MEM_WR,
            O_MEM_RD => C_MEM_RD
        );

    memory : entity work.memory
        generic map(INIT_FILE => INIT_FILE)
        port map(
            I_CLK => I_CLK,
            I_RST => L_RST,
            I_PC => C_PC,
            I_MEM_ADDR => C_MEM_ADDR,
            I_WR_DATA => C_MEM_DATA,
            I_MEM_WR => C_MEM_WR,
            I_MEM_RD => C_MEM_RD,
            O_INSTRUCTION => M_INSTRUCTION,
            O_DATA => M_DATA
        );

    L_RST <= not I_RST_N;
end behavioural;