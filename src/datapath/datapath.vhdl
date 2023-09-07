library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity datapath is
    generic (
        INIT_FILE : string := "program.hex"
    );
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        -- IF CONTROL SIGNALS
        I_BRANCH : in std_logic;
        I_IF_FLUSH : in std_logic;
        -- EX CONTROL SIGNALS
        I_REG_DST : in std_logic;
        I_ALU_CONTROL : in ALUControl;
        I_ALU_SRC : in std_logic;
        -- MEM CONTROL SIGNALS
        I_MEM_RD : in std_logic;
        I_MEM_WR : in std_logic;
        -- WB CONTROL SIGNALS
        I_MEM_TO_REG : in std_logic;
        I_REG_WRITE : in std_logic;
        -- FORWARDING CONTROL SIGNALS
        I_FORWARD_SEL_A : in std_logic_vector(1 downto 0);
        I_FORWARD_SEL_B : in std_logic_vector(1 downto 0);
        -- HAZARD DETECTION
        I_PC_WRITE : in std_logic;
        I_IF_ID_WRITE : in std_logic;
        -- CONTROL OUTPUTS
        O_EQUALS : out std_logic; -- for control unit
        O_INSTRUCTION : out std_logic_vector(31 downto 0); -- for control unit & hazard detection
        O_ID_EX_RT : out std_logic_vector(4 downto 0);-- for forwarding & hazard detection
        O_ID_EX_RS : out std_logic_vector(4 downto 0); -- for forwarding
        O_EX_MEM_REG_DST : out std_logic_vector(4 downto 0); -- for forwarding
        O_MEM_WB_REG_DST : out std_logic_vector(4 downto 0) -- for forwarding
    );
end datapath;

architecture behavioural of datapath is
    signal F_INSTRUCTION : std_logic_vector(31 downto 0) := (others => '0');
    signal F_NEXT_PC : std_logic_vector(31 downto 0) := (others => '0');

    signal D_RD_DATA_1 : std_logic_vector(31 downto 0) := (others => '0');
    signal D_RD_DATA_2 : std_logic_vector(31 downto 0) := (others => '0');
    signal D_REG_RS : std_logic_vector(4 downto 0) := (others => '0');
    signal D_REG_RT : std_logic_vector(4 downto 0) := (others => '0');
    signal D_REG_RD : std_logic_vector(4 downto 0) := (others => '0');
    signal D_IMMIDIATE : std_logic_vector(31 downto 0) := (others => '0');
    signal D_NEXT_PC : std_logic_vector(31 downto 0) := (others => '0');

    signal E_ALU_RESULT : std_logic_vector(31 downto 0) := (others => '0');
    signal E_MEM_WR_DATA : std_logic_vector(31 downto 0) := (others => '0');
    signal E_DST_REG : std_logic_vector(4 downto 0) := (others => '0');

    signal M_RD_DATA : std_logic_vector(31 downto 0) := (others => '0');
    signal M_ALU_RESULT : std_logic_vector(31 downto 0) := (others => '0');
    signal M_DST_REG : std_logic_vector(4 downto 0) := (others => '0');

    signal L_WR_DATA : std_logic_vector(31 downto 0) := (others => '0');
begin
    instruction_fetch : entity work.instruction_fetch
        generic map(
            INIT_FILE => INIT_FILE
        )
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST,
            I_NEW_PC => D_NEXT_PC,
            I_BRANCH => I_BRANCH,
            I_IF_FLUSH => I_IF_FLUSH,
            I_PC_WRITE => I_PC_WRITE,
            I_IF_ID_WRITE => I_IF_ID_WRITE,
            O_INSTRUCTUION => F_INSTRUCTION,
            O_NEXT_PC => F_NEXT_PC
        );

    instruction_decode : entity work.instruction_decode
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST,
            I_REG_WRITE => I_REG_WRITE,
            I_INSTRUCTION => F_INSTRUCTION,
            I_NEXT_PC => F_NEXT_PC,
            I_WR_ADDR => M_DST_REG,
            I_WR_DATA => L_WR_DATA,
            O_RD_DATA_1 => D_RD_DATA_1,
            O_RD_DATA_2 => D_RD_DATA_2,
            O_REG_RS => D_REG_RS,
            O_REG_RT => D_REG_RT,
            O_REG_RD => D_REG_RD,
            O_IMMIDIATE => D_IMMIDIATE,
            O_NEXT_PC => D_NEXT_PC,
            O_REG_EQ => O_EQUALS
        );

    execution : entity work.execution
        port map(
            I_CLK => I_CLK,
            I_ALU_CONTROL => I_ALU_CONTROL,
            I_ALU_SRC => I_ALU_SRC,
            I_FORWARD_SEL_A => I_FORWARD_SEL_A,
            I_FORWARD_SEL_B => I_FORWARD_SEL_B,
            I_REG_DST => I_REG_DST,
            I_RD_DATA_1 => D_RD_DATA_1,
            I_RD_DATA_2 => D_RD_DATA_2,
            I_IMMIDIATE => D_IMMIDIATE,
            I_REG_RT => D_REG_RT,
            I_REG_RD => D_REG_RD,
            I_ALU_RESULT => E_ALU_RESULT,
            I_WB_DATA => L_WR_DATA,
            O_ALU_RESULT => E_ALU_RESULT,
            O_MEM_WR_DATA => E_MEM_WR_DATA,
            O_DST_REG => E_DST_REG
        );

    memory : entity work.memory
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST,
            I_MEM_RD => I_MEM_RD,
            I_MEM_WR => I_MEM_WR,
            I_ALU_RESULT => E_ALU_RESULT,
            I_WR_DATA => E_MEM_WR_DATA,
            I_DST_REG => E_DST_REG,
            O_RD_DATA => M_RD_DATA,
            O_ALU_RESULT => M_ALU_RESULT,
            O_DST_REG => M_DST_REG
        );

    L_WR_DATA <= M_ALU_RESULT when I_MEM_TO_REG = '1' else
        M_RD_DATA;

    O_INSTRUCTION <= F_INSTRUCTION;
    O_ID_EX_RS <= D_REG_RS;
    O_ID_EX_RT <= D_REG_RT;
    O_EX_MEM_REG_DST <= E_DST_REG;
    O_MEM_WB_REG_DST <= M_DST_REG;

end architecture;