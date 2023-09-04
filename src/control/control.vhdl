library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity control_unit is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        -- DATAPATH REGISTERS
        I_INSTRUCTION : in std_logic_vector(31 downto 0); -- for control unit & hazard detection
        I_EX_MEM_REG_RD : in std_logic_vector(4 downto 0); -- for forwarding
        I_MEM_WB_REG_RD : in std_logic_vector(4 downto 0); -- for forwarding
        I_ID_EX_RS : in std_logic_vector(4 downto 0); -- for forwarding
        I_ID_EX_RT : in std_logic_vector(4 downto 0); -- for forwarding & hazard detection
        -- EX CONTROL SIGNALS
        O_REG_DST : out std_logic;
        O_ALU_CONTROL : out ALUControl;
        O_ALU_SRC : out std_logic;
        -- MEM CONTROL SIGNALS
        O_BRANCH : out std_logic;
        -- WB CONTROL SIGNALS
        O_MEM_TO_REG : out std_logic;
        O_REG_WRITE : out std_logic;
        -- FORWARDING CONTROL SIGNALS
        O_FORWARD_SEL_A : out std_logic;
        O_FORWARD_SEL_B : out std_logic;
        -- HAZARD DETECTION
        O_PC_WRITE : out std_logic;
        O_IF_ID_WRITE : out std_logic
    );
end control_unit;

architecture behavioural of control_unit is

begin

end architecture;