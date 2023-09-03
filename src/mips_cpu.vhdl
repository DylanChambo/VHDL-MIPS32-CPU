library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic
    );
end cpu;

architecture behavioural of cpu is
    signal D_INSTRUCTION : unsigned(31 downto 0);
    signal D_EX_MEM_REG_RD : unsigned(4 downto 0);
    signal D_MEM_WB_REG_RD : unsigned(4 downto 0);
    signal D_ID_EX_RS : unsigned(4 downto 0);
    signal D_ID_EX_RT : unsigned(4 downto 0);

    signal C_REG_DST : std_logic;
    signal C_ALU_CONTROL : unsigned(3 downto 0);
    signal C_ALU_SRC : std_logic;
    signal C_BRANCH : std_logic;
    signal C_MEM_TO_REG : std_logic;
    signal C_REG_WRITE : std_logic;
    signal C_FORWARD_SEL_A : unsigned(1 downto 0);
    signal C_FORWARD_SEL_B : unsigned(1 downto 0);
    signal C_PC_WRITE : std_logic;
    signal C_IF_ID_WRITE : std_logic;

    signal L_PC : unsigned(7 downto 0);
begin
    -- Instantiate the components
    control_unit : entity work.control_unit
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST,
            I_INSTRUCTION => D_INSTRUCTION,
            I_EX_MEM_REG_RD => D_EX_MEM_REG_RD,
            I_MEM_WB_REG_RD => D_MEM_WB_REG_RD,
            I_ID_EX_RS => D_ID_EX_RS,
            I_ID_EX_RT => D_ID_EX_RT,
            O_REG_DST => C_REG_DST,
            O_ALU_CONTROL => C_ALU_CONTROL,
            O_ALU_SRC => C_ALU_SRC,
            O_BRANCH => C_BRANCH,
            O_MEM_TO_REG => C_MEM_TO_REG,
            O_REG_WRITE => C_REG_WRITE,
            O_FORWARD_SEL_A => C_FORWARD_SEL_A,
            O_FORWARD_SEL_B => C_FORWARD_SEL_B,
            O_PC_WRITE => C_PC_WRITE,
            O_IF_ID_WRITE => C_IF_ID_WRITE
        );

    datapath : entity work.datapath
        port map(
            I_CLK => I_CLK,
            I_RST => I_RST
            I_REG_DST
            I_ALU_CONTROL
            I_ALU_SRC
            I_BRANCH
            I_MEM_TO_REG
            I_REG_WRITE
            I_FORWARD_SEL_A
            I_FORWARD_SEL_B
            I_PC_WRITE
            I_IF_ID_WRITE
            O_INSTRUCTION => D_INSTRUCTION,
            O_EX_MEM_REG_RD => D_EX_MEM_REG_RD,
            O_MEM_WB_REG_RD => D_MEM_WB_REG_RD,
            O_ID_EX_RS => D_ID_EX_RS,
            O_ID_EX_RT => D_ID_EX_RT
        );
end behavioural;