library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.pkg_common.all;

entity counter is
    port(
        clk: in std_logic;
        reset: in std_logic;
        data: out vector_8
    );
end entity counter;

architecture sync of counter is
    constant reset_value : vector_8 := (others => '0');

    signal current_value: vector_8 := (others => '0');
    signal next_value: vector_8;
begin
    process(clk,reset)
    begin
        if clk = '1' then
            if reset = '1' then
                current_value <= reset_value;
            else
                current_value <= next_value;
            end if;
        end if;
    end process;

    process (current_value)
    begin
        next_value <= current_value +1;
    end process;

    data <= current_value;

end architecture sync;