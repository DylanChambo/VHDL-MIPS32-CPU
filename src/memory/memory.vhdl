library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.init_mem.all;

entity memory is
    generic (
        INIT_FILE : string := "program.hex"
    );
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        -- INSTRUCTION Signals
        I_PC : in std_logic_vector(31 downto 0);
        -- Control Signals
        I_MEM_RD : in std_logic;
        I_MEM_WR : in std_logic;
        -- DA Signals
        I_MEM_ADDR : in std_logic_vector(31 downto 0);
        I_WR_DATA : in std_logic_vector(31 downto 0);
        -- Outputs
        O_INSTRUCTION : out std_logic_vector(31 downto 0);
        O_DATA : out std_logic_vector(31 downto 0)
    );
end memory;

architecture behavioural of memory is
    constant MEM : T_MEMORY := init_memory(INIT_FILE);
    signal D_DATA : std_logic_vector(31 downto 0) := (others => '0');
    signal L_MEM_RD : std_logic := '0';
    signal L_MEM_WR : std_logic := '0';
    signal L_IO_RD : std_logic := '0';
    signal L_IO_WR : std_logic := '0';
    signal L_PC : std_logic_vector(31 downto 0) := (others => '0');
    signal L_ADDR : std_logic_vector(31 downto 0) := (others => '0');
    signal L_MEM_MAP_ADDR : std_logic_vector(31 downto 0) := (others => '0');
    signal L_MEM_MAP : std_logic := '0';
begin
    -- 0x0000 to 0x03FF is reserved for the text segment (1024B) (256 instructions)
    -- 0x1000 to 0x13FF is reserved for the data segment (1024B) (256 words)
    -- 0x2000 to 0x2FFF is reserved for the stack segment (4096B) (1024 words)
    -- 0x3000 to 0x3010 is reserved for Memory Mapperd IO (16B) (4 words)
    -- 0x8000 to 0x83FF is reserved for the kernal text memory (1024B) (256 words)
    -- 0x9000 to 0x93FF is reserved for the kernal data memory (1024B) (256 words)
    instruction_memory : entity work.instruction_mem
        generic map(
            INIT_MEM => MEM.text
        )
        port map(
            I_PC => L_PC,
            O_INSTRUCTION => O_INSTRUCTION
        );

    data_memory : entity work.data_mem
        generic map(
            INIT_MEM => MEM.data
        )
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST,
            I_ADDR => L_ADDR,
            I_DATA => I_WR_DATA,
            I_RD_EN => L_MEM_RD,
            I_WR_EN => L_MEM_WR,
            O_DATA => D_DATA
        );

    -- memory_map_io : entity work.memory_map
    --     port map();

    L_PC <= x"00000" & I_PC(11 downto 0) when I_PC(15 downto 12) = x"0" else
        x"00000" & I_PC(11 downto 0) + x"000003FF" when I_PC(15 downto 12) = x"8" else
        (others => '0');

    L_ADDR <= x"00000" & I_MEM_ADDR(11 downto 0) when I_MEM_ADDR(17 downto 14) = x"1" else
        x"00000" & I_MEM_ADDR(11 downto 0) + x"000003FF" when I_MEM_ADDR(15 downto 12) = x"2" else
        x"00000" & I_MEM_ADDR(11 downto 0) + x"00000FFF" when I_MEM_ADDR(15 downto 12) = x"9" else
        (others => '0');

    L_MEM_MAP_ADDR <= x"00000" & I_MEM_ADDR(11 downto 0);

    L_MEM_MAP <= '1' when I_MEM_ADDR(15 downto 12) = x"3" else
        '0';

    L_MEM_RD <= I_MEM_RD when L_MEM_MAP = '0' else
        '0';
    L_MEM_WR <= I_MEM_WR when L_MEM_MAP = '0' else
        '0';
    L_IO_RD <= I_MEM_RD when L_MEM_MAP = '1' else
        '0';
    L_IO_WR <= I_MEM_WR when L_MEM_MAP = '1' else
        '0';

    O_DATA <= D_DATA when L_MEM_MAP = '0' else
        (others => '0');
end architecture;