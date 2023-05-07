-- Copyright: IBE Ermisch GmbH
-- Author: Vinícius Gabriel Linden
-- Date: 2023-02-14
-- Brief: Utilities package

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

package pkg_common is

    subtype vector_8 is std_logic_vector(7 downto 0);
    subtype vector_16 is std_logic_vector(15 downto 0);
    type matrix_16 is array (integer range <>) of vector_16;

    subtype signed_16 is signed(15 downto 0);
    type smatrix_16 is array (integer range <>) of signed_16;

    subtype unsigned_8 is unsigned(7 downto 0);
    subtype unsigned_16 is unsigned(15 downto 0);

    -- brief ln calculation
    -- param x Number to calculate
    -- returns Calculated ln value
    function log2(x: natural) return integer;

    -- brief Number of bits necessary to represent an amount of values
    -- param x Number to represent
    -- returns Minimal bitwidth
    function bitwidth(x: integer) return integer;

    -- brief Reverse bit order (bit endianess)
    -- param x Vector to reverse bits
    -- returns Vector with reversed bits
    function swap_bits(x: std_logic_vector) return std_logic_vector;

    -- brief Reverse bit order of each byte of the vector; the byte order itself stay the same
    -- param x Vector to reverse each byte
    -- returns Vector with reversed bytes
    function reverse_bytes(x: std_logic_vector) return std_logic_vector;

    -- brief Convert boolean to PIN_TYPE vector
    -- param output If pad is an output.
    -- returns Vector with appropriate PIN_TYPE
    function pin_type(output : boolean) return bit_vector;

end pkg_common;

package body pkg_common is

    function log2(x : natural) return integer is
    begin
        return integer(ceil(log2(real(x))));
    end function;

    function bitwidth(x: integer) return integer is
        variable y : integer;
    begin
        y := x + 1;
        if y = 0 or y = 1 then
            return 1;
        else
            return log2(y);
        end if;
    end bitwidth;

    function swap_bits(x: std_logic_vector) return std_logic_vector is
        variable result : std_logic_vector(x'range);
    begin
        if x'high - x'low = 0 then
            result := x;
        else
            for i in 0 to (x'high - x'low) loop
                result(x'high - i) := x(x'low + i);
            end loop;
        end if;
        return result;
    end swap_bits;

    function reverse_bytes(x: std_logic_vector) return std_logic_vector is
        variable result : std_logic_vector(x'range);
        variable idx : integer;
    begin
        if x'high - x'low = 0 then
            result := x;
        else
            idx := 0;
            while idx < x'high loop
                result(idx+7 downto idx) := swap_bits(x(idx+7 downto idx));
                idx := idx + 8;
            end loop;
        end if;
        return result;
    end reverse_bytes;

    function pin_type(output : boolean)
        return bit_vector is
    begin
        if output then
            return "011001";
        else
            return "000001";
        end if;
    end function pin_type;

end pkg_common;
