library ieee;
use ieee.std_logic_1164.all;--
use ieee.numeric_std.all;               -- for type conversions

entity inc4 is
	generic (
		N : integer := 32
	);
	port (
		p4_in : in std_logic_vector(N-1 downto 0);
		p4_out : out std_logic_vector(N-1 downto 0)
	) ;
end inc4;

architecture inc4_arc of inc4 is

begin


p4_out <= std_logic_vector(unsigned(p4_in) + (to_unsigned(4, N)));

end  inc4_arc;