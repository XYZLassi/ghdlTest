library ieee;
use ieee.std_logic_1164.all;

use work.pkg_common.all;
library sb_ice40_components_syn;
use sb_ice40_components_syn.components.all;

entity main is
    port (
        cs1to4 : inout std_logic; -- i3c
        clk_ref : in std_logic;

        in_1 : in std_logic;
        in_2 : in std_logic;
        out_1 : out std_logic
    );
end main;

architecture arch of main is
    signal cs : std_logic := '1';
begin
    out_1 <= in_1 and in_2;

    PDM1_I3C : entity work.i3c
    generic map (
        OUTPUT_PAD => true
    )
    port map (
       pad => cs1to4,
        logic_in => cs,
        logic_out => open
    );
end arch;
