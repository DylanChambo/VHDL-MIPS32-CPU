library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity datapath is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        -- EX CONTROL SIGNALS
        I_REG_DST : in std_logic;
        I_ALU_CONTROL : in ALUControl;
        I_ALU_SRC : in std_logic;
        -- MEM CONTROL SIGNALS
        I_BRANCH : in std_logic;
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

begin
    instruction_memory : entity work.program_memory
        port map();

    data : entity work.control_unit
        port map();

end architecture;