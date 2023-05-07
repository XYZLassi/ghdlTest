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
    signal data: vector_8;
begin

    out_1 <= data(7);

end arch;
