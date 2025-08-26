library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register is
    generic (
        WIDTH : integer := 8
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        shift_en: in  std_logic;
        data_in : in  std_logic;
        q       : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture Behavioral of shift_register is
    signal reg : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if shift_en = '1' then
                reg <= data_in & reg(WIDTH-1 downto 1);
            end if;
        end if;
    end process;
    q <= reg;
end Behavioral;
