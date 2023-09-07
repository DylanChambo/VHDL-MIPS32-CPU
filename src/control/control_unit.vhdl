library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity control_unit is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        -- DATAPATH REGISTERS
        I_INSTRUCTION : in std_logic_vector(31 downto 0); -- for control & hazard detection
        I_EQUALS : in std_logic; -- for control
        I_EX_MEM_REG_RD : in std_logic_vector(4 downto 0); -- for forwarding
        I_MEM_WB_REG_RD : in std_logic_vector(4 downto 0); -- for forwarding
        I_ID_EX_RS : in std_logic_vector(4 downto 0); -- for forwarding
        I_ID_EX_RT : in std_logic_vector(4 downto 0); -- for forwarding & hazard detection
        -- IF CONTROL SIGNALS
        O_BRANCH : out std_logic;
        O_IF_FLUSH : out std_logic;
        -- EX CONTROL SIGNALS
        O_REG_DST : out std_logic;
        O_ALU_CONTROL : out ALUControl;
        O_ALU_SRC : out std_logic;
        -- MEM CONTROL SIGNALS
        O_MEM_RD : out std_logic;
        O_MEM_WR : out std_logic;
        -- WB CONTROL SIGNALS
        O_MEM_TO_REG : out std_logic;
        O_REG_WR : out std_logic;
        -- FORWARDING CONTROL SIGNALS
        O_FORWARD_SEL_A : out std_logic_vector(1 downto 0);
        O_FORWARD_SEL_B : out std_logic_vector(1 downto 0);
        -- HAZARD DETECTION
        O_PC_WRITE : out std_logic;
        O_IF_ID_WRITE : out std_logic
    );
end control_unit;

architecture behavioural of control_unit is
    signal C_BRANCH : std_logic;
    signal C_ID_FLUSH : std_logic;
    signal C_EX_FLUSH : std_logic;
    signal C_REG_DST : std_logic;
    signal C_ALU_OP : std_logic_vector(2 downto 0);
    signal C_ALU_SRC : std_logic;
    signal C_MEM_RD : std_logic;
    signal C_MEM_WR : std_logic;
    signal C_REG_WR : std_logic;
    signal C_MEM_TO_REG : std_logic;

    signal H_FLUSH : std_logic;

    signal L_ALU_OP : std_logic_vector(2 downto 0);
    signal L_EX_MEM_RD : std_logic;
    signal L_EX_MEM_WR : std_logic;
    signal L_EX_REG_WR : std_logic;
    signal L_MEM_REG_WR : std_logic;
    signal L_EX_MEM_TO_REG : std_logic;
    signal L_MEM_MEM_TO_REG : std_logic;
begin
    control : entity work.main_control
        port map(
            I_INSTRUCTION => I_INSTRUCTION,
            O_IF_FLUSH => O_IF_FLUSH,
            O_ID_FLUSH => C_ID_FLUSH,
            O_EX_FLUSH => C_EX_FLUSH,
            O_BRANCH => C_BRANCH,
            O_REG_DST => C_REG_DST,
            O_ALU_OP => C_ALU_OP,
            O_ALU_SRC => C_ALU_SRC,
            O_MEM_RD => C_MEM_RD,
            O_MEM_WR => C_MEM_WR,
            O_MEM_TO_REG => C_MEM_TO_REG,
            O_REG_WR => C_REG_WR
        );

    process (I_CLK)
    begin
        if rising_edge(I_CLK) then
            -- ID/EX Control Register
            if (C_ID_FLUSH = '1' or H_FLUSH = '1') then
                O_REG_DST <= '0';
                O_ALU_SRC <= '0';
                L_ALU_OP <= "000";
                L_EX_MEM_RD <= '0';
                L_EX_MEM_WR <= '0';
                L_EX_REG_WR <= '0';
                L_EX_MEM_TO_REG <= '0';
            else
                O_REG_DST <= C_REG_DST;
                L_ALU_OP <= C_ALU_OP;
                O_ALU_SRC <= C_ALU_SRC;
                L_EX_MEM_RD <= C_MEM_RD;
                L_EX_MEM_WR <= C_MEM_WR;
                L_EX_REG_WR <= C_REG_WR;
                L_EX_MEM_TO_REG <= C_MEM_TO_REG;
            end if;

            -- EX/MEM Control Register
            if (C_EX_FLUSH = '1') then
                O_MEM_RD <= '0';
                O_MEM_WR <= '0';
                L_EX_REG_WR <= '0';
                L_EX_MEM_TO_REG <= '0';
            else
                O_MEM_RD <= L_EX_MEM_RD;
                O_MEM_WR <= L_EX_MEM_WR;
                L_MEM_REG_WR <= L_EX_REG_WR;
                L_MEM_MEM_TO_REG <= L_EX_MEM_TO_REG;
            end if;

            -- MEM/WB Control Register
            O_MEM_TO_REG <= L_MEM_MEM_TO_REG;
            O_REG_WR <= L_MEM_REG_WR;
        end if;
    end process;

    O_BRANCH <= C_BRANCH and I_EQUALS;
end architecture;