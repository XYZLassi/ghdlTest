library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_common.all;

entity tb_counter is
end entity tb_counter;

architecture behavior of tb_counter is
    signal clk:  std_logic := '0';
    signal rst:  std_logic := '0';
    signal data: vector_8;
begin

    -- Instantiation of the DUT
    u0: entity work.counter(sync)
    port map(
        clk => clk,
        reset => rst,
        data  => data
    );

    -- A clock generating process with a 2ns clock period. The process
    -- being an infinite loop, the clock will never stop toggling.
    process
    begin
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end process;

    process
        begin
        rst  <= '0';

        for i in 0 to 10 loop
            wait until rising_edge(clk);
            assert unsigned(data) = i 
            report "Assertion violation.: " & to_string(unsigned(data)) & " to " & to_string(i)  severity failure;
        end loop;
        rst  <= '1';
        wait;
    end process;

end architecture behavior;