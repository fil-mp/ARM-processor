library ieee;
use ieee.std_logic_1164.all; --
use ieee.numeric_std.all;               -- for type conversions

entity muxp4 is
	generic (
		N : integer := 32
	);
	port (
		ctr : in std_logic;
		i_act1 : in std_logic_vector(N-1 downto 0);  
		i_act0     : in std_logic_vector(N-1 downto 0); 
		o_mux    : out std_logic_vector(N-1 downto 0)
	) ;
end muxp4;

architecture muxp4_arc of muxp4 is

begin

	MUX : process( i_act0,i_act1,ctr)
	begin
		if ctr = '1' then 
			o_mux <= i_act1 ;
		else
			o_mux <= i_act0;
		end if;
	end process ; -- MUX

end  muxp4_arc;


