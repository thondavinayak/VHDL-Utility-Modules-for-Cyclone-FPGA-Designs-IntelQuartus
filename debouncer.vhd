library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    generic (
        N : integer := 20  -- debounce cycles
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        btn_in  : in  std_logic;
        btn_out : out std_logic
    );
end entity;

architecture Behavioral of debouncer is
    signal counter : unsigned(N-1 downto 0) := (others => '0');
    signal sync, btn_reg : std_logic := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
            btn_reg <= '0';
            sync    <= '0';
        elsif rising_edge(clk) then
            if btn_in = sync then
                if counter /= (others => '1') then
                    counter <= counter + 1;
                else
                    btn_reg <= sync;
                end if;
            else
                counter <= (others => '0');
                sync    <= btn_in;
            end if;
        end if;
    end process;
    btn_out <= btn_reg;
end Behavioral;
