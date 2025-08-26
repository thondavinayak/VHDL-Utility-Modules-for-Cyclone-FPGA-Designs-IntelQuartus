library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    generic (
        CLK_FREQ : integer := 50_000_000;
        BAUD     : integer := 9600
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        tx_start: in  std_logic;
        tx_data : in  std_logic_vector(7 downto 0);
        tx      : out std_logic;
        busy    : out std_logic
    );
end entity;

architecture Behavioral of uart_tx is
    constant BAUD_TICKS : integer := CLK_FREQ / BAUD;
    signal counter : integer range 0 to BAUD_TICKS-1 := 0;
    signal bit_cnt : integer range 0 to 9 := 0;
    signal shreg   : std_logic_vector(9 downto 0);
    signal tx_reg  : std_logic := '1';
    signal active  : std_logic := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            tx_reg <= '1';
            active <= '0';
            counter <= 0;
            bit_cnt <= 0;
        elsif rising_edge(clk) then
            if active = '0' then
                if tx_start = '1' then
                    shreg <= '0' & tx_data & '1'; -- start, data, stop
                    active <= '1';
                    bit_cnt <= 0;
                    counter <= 0;
                end if;
            else
                if counter = BAUD_TICKS-1 then
                    counter <= 0;
                    tx_reg <= shreg(bit_cnt);
                    if bit_cnt = 9 then
                        active <= '0';
                    else
                        bit_cnt <= bit_cnt + 1;
                    end if;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    tx   <= tx_reg;
    busy <= active;
end Behavioral;
