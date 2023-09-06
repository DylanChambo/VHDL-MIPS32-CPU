library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity datapath is
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
        I_MEM_READ : in std_logic;
        I_MEM_WRITE : in std_logic;
        -- WB CONTROL SIGNALS
        I_MEM_TO_REG : in std_logic;
        I_REG_WRITE : in std_logic;
        -- FORWARDING CONTROL SIGNALS
        I_FORWARD_SEL_A : in std_logic;
        I_FORWARD_SEL_B : in std_logic;
        -- HAZARD DETECTION
        I_PC_WRITE : in std_logic;
        I_IF_ID_WRITE : in std_logic;
        -- CONTROL OUTPUTS
        O_EQUALS : out std_logic; -- for control unit
        O_INSTRUCTION : out std_logic_vector(31 downto 0); -- for control unit & hazard detection
        O_ID_EX_RT : out std_logic_vector(4 downto 0);-- for forwarding & hazard detection
        O_ID_EX_RS : out std_logic_vector(4 downto 0); -- for forwarding
        O_EX_MEM_REG_RD : out std_logic_vector(4 downto 0); -- for forwarding
        O_MEM_WB_REG_RD : out std_logic_vector(4 downto 0) -- for forwarding
    );
end datapath;

architecture behavioural of datapath is
    signal F_INSTRUCTION : std_logic_vector(31 downto 0);
    signal F_NEXT_PC : std_logic_vector(31 downto 0);

    signal D_RD_DATA_1 : std_logic_vector(31 downto 0);
    signal D_RD_DATA_2 : std_logic_vector(31 downto 0);
    signal D_REG_RS : std_logic_vector(4 downto 0);
    signal D_REG_RT : std_logic_vector(4 downto 0);
    signal D_REG_RD : std_logic_vector(4 downto 0);
    signal D_IMMIDIATE : std_logic_vector(15 downto 0);
    signal D_NEXT_PC : std_logic_vector(31 downto 0);
begin
    instruction_fetch : entity work.instruction_fetch
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
            I_WR_ADDR => open,
            I_WR_DATA => open,
            O_RD_DATA_1 => D_RD_DATA_1,
            O_RD_DATA_2 => D_RD_DATA_2,
            O_REG_RS => D_REG_RS,
            O_REG_RT => D_REG_RT,
            O_REG_RD => D_REG_RD,
            O_IMMIDIATE => D_IMMIDIATE,
            O_NEXT_PC => D_NEXT_PC,
            O_REG_EQ => O_EQUALS
        );

end architecture;