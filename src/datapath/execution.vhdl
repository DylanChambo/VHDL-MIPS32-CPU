library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
entity execution is
    port (
        I_CLK : in std_logic;
        -- Control Signals
        I_ALU_CONTROL : AluControl;
        I_ALU_SRC : in std_logic;
        I_FORWARD_SEL_A : in std_logic_vector(1 downto 0);
        I_FORWARD_SEL_B : in std_logic_vector(1 downto 0);
        I_REG_DST : in std_logic;
        -- Instruction Decode Signals
        I_RD_DATA_1 : in std_logic_vector(31 downto 0);
        I_RD_DATA_2 : in std_logic_vector(31 downto 0);
        I_IMMIDIATE : in std_logic_vector(31 downto 0);
        I_REG_RT : in std_logic_vector(4 downto 0);
        I_REG_RD : in std_logic_vector(4 downto 0);
        -- Previous Execution Signals
        I_ALU_RESULT : in std_logic_vector(31 downto 0);
        -- Write Back Signals
        I_WB_DATA : in std_logic_vector(31 downto 0);
        O_ALU_RESULT : out std_logic_vector(31 downto 0);
        O_MEM_WR_DATA : out std_logic_vector(31 downto 0);
        O_DST_REG : out std_logic_vector(4 downto 0)
    );
end execution;

architecture behavioural of execution is
    signal L_ALU_A : std_logic_vector(31 downto 0);
    signal L_ALU_B : std_logic_vector(31 downto 0);
    signal L_REG_2 : std_logic_vector(31 downto 0);
    signal L_DST_REG : std_logic_vector(4 downto 0);
    signal A_RESULT : std_logic_vector(31 downto 0);
begin
    alu : entity work.alu
        port map(
            I_A => L_ALU_A,
            I_B => L_ALU_B,
            I_CONTROL => I_ALU_CONTROL,
            O_RESULT => A_RESULT,
            O_ZERO => open
        );

    process (I_CLK)
    begin
        if rising_edge(I_CLK) then
            O_ALU_RESULT <= A_RESULT;
            O_MEM_WR_DATA <= L_REG_2;
            O_DST_REG <= L_DST_REG;
        end if;
    end process;

    L_ALU_A <= I_RD_DATA_1 when(I_FORWARD_SEL_A = "00") else
        I_ALU_RESULT when(I_FORWARD_SEL_A = "01") else
        I_WB_DATA when(I_FORWARD_SEL_A = "10") else
        (others => '0');
    L_REG_2 <= I_RD_DATA_2 when(I_FORWARD_SEL_B = "00") else
        I_ALU_RESULT when(I_FORWARD_SEL_B = "01") else
        I_WB_DATA when(I_FORWARD_SEL_B = "10") else
        (others => '0');
    L_ALU_B <= I_IMMIDIATE when (I_ALU_SRC = '1') else
        L_REG_2;

    L_DST_REG <= I_REG_RT when I_REG_DST <= '0' else
        I_REG_RD;
end architecture;