library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity datapath is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        -- ID CONTROL SIGNALS
        I_BRANCH : in std_logic;
        I_IF_FLUSH : in std_logic;
        I_ID_FLSUH : in std_logic;
        I_EX_FLSUH : in std_logic;
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
        O_INSTRUCTION : out std_logic_vector(31 downto 0); -- for control unit & hazard detection
        O_EX_MEM_REG_RD : out std_logic_vector(4 downto 0); -- for forwarding
        O_MEM_WB_REG_RD : out std_logic_vector(4 downto 0); -- for forwarding
        O_ID_EX_RS : out std_logic_vector(4 downto 0); -- for forwarding
        O_ID_EX_RT : out std_logic_vector(4 downto 0) -- for forwarding & hazard detection
    );
end datapath;

architecture behavioural of datapath is
    signal L_R_WR_ADDR : std_logic_vector(4 downto 0);
    signal L_R_WR_DATA : std_logic_vector(31 downto 0);
    signal L_R_RD_ADDR_1 : std_logic_vector(4 downto 0);
    signal L_R_RD_ADDR_2 : std_logic_vector(4 downto 0);
    signal L_ALU_A : std_logic_vector(31 downto 0);
    signal L_ALU_B : std_logic_vector(31 downto 0);
    signal L_DM_ADDR : std_logic_vector(31 downto 0);
    signal L_DM_DATA : std_logic_vector(31 downto 0);

    signal R_RD_DATA_1 : std_logic_vector(31 downto 0);
    signal R_RD_DATA_2 : std_logic_vector(31 downto 0);

    signal ALU_RESULT : std_logic_vector(31 downto 0);
    signal ALU_ZERO : std_logic;

    signal DM_DATA : std_logic_vector(31 downto 0);
begin
    instruction_memory : entity work.instruction_mem
        port map(
            I_PC => IM_PC,
            O_INSTRUCTION => IM_INSTRUCTION
        );

    register_file : entity work.register_file
        port map(
            I_CLK => I_CLK
            I_RST => I_RST
            I_WR_ADDR => L_R_WR_ADDR
            I_WR_DATA => L_R_WR_DATA
            I_WR_EN => I_REG_WRITE
            I_RD_ADDR_1 => L_R_RD_ADDR_1
            I_RD_ADDR_2 => L_R_RD_ADDR_2
            O_RD_DATA_1 => R_RD_DATA_1,
            O_RD_DATA_2 => R_RD_DATA_2
        );

    alu : entity work.alu
        port map(
            I_A => L_ALU_A
            I_B => L_ALU_B
            I_CONTROL => I_ALU_CONTROL
            O_RESULT => ALU_RESULT
            O_ZERO => ALU_ZERO
        );

    data_memory : entity work.data_mem
        port map(
            I_CLK => I_CLK,
            I_ADDR => L_DM_ADDR,
            I_DATA => L_DM_DATA,
            I_RD_EN => I_MEM_READ,
            I_WR_EN => I_MEM_WRITE,
            O_DATA : DM_Data
        );