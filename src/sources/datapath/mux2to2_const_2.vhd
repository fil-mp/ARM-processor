library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity mux2to2_const_2 is
	generic (
			N : integer := 32
		);
	port (
		regSrc : in std_logic;
		Rinput : in std_logic_vector(N-1 downto 0);
		Rout : out std_logic_vector(N-1 downto 0)

	) ;
end mux2to2_const_2;

architecture mux2to2_const_2_arc of mux2to2_const_2 is

begin

process(regSrc,Rinput)
begin
	case(regSrc) is
		when '0'  => 
			Rout <= Rinput;
		when others =>
			Rout <= "1110";
	end case;
end process;
end  mux2to2_const_2_arc;