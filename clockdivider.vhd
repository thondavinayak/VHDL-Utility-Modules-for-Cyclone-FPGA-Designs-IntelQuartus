library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    generic (
        DIVISOR : integer := 50_000_000  -- divide 50 MHz to 1 Hz
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        clk_out : out std_logic
    );
end entity;

architecture Behavioral of clock_divider is
    signal counter : integer range 0 to DIVISOR-1 := 0;
    signal clk_reg : std_logic := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            clk_reg <= '0';
        elsif rising_edge(clk) then
            if counter = DIVISOR-1 then
                counter <= 0;
                clk_reg <= not clk_reg;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    clk_out <= clk_reg;
end Behavioral;
