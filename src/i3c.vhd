library ieee;
use ieee.std_logic_1164.all;

library sb_ice40_components_syn;
use sb_ice40_components_syn.components.all;

use work.pkg_common.all;

entity i3c is
    generic (
        OUTPUT_PAD : boolean := false -- false for input pad, true for output pad
    );
    port (
        pad : inout std_logic;
        logic_in : in std_logic; -- when pad is an output
        logic_out : out std_logic -- when pad is an input
    );
end i3c;

architecture arch of i3c is

    attribute PULLUP_RESISTOR : string;
    attribute PULLUP_RESISTOR of I3C_PRIMITIVE : label is "10K";

begin

    I3C_PRIMITIVE : SB_IO_I3C
    generic map (
        PIN_TYPE => pin_type(OUTPUT_PAD),
        PULLUP => '1',
        WEAK_PULLUP => '0',
        NEG_TRIGGER => '0',
        IO_STANDARD => "SB_LVCMOS"
    )
    port map (
        PACKAGE_PIN => pad,
        LATCH_INPUT_VALUE => '0',
        CLOCK_ENABLE => '0',
        INPUT_CLK => '0',
        OUTPUT_CLK => '0',
        OUTPUT_ENABLE => '0',
        D_OUT_1 => '0',
        D_OUT_0 => logic_in,
        PU_ENB => '1',
        WEAK_PU_ENB => '0',
        D_IN_1 => open,
        D_IN_0 => logic_out
    );

end arch;