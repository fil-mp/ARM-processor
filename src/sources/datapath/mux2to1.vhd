library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

entity mux2to1 is
	generic (
		N : integer 
	);
	port (
		ALUSrc : in std_logic;
		inp1 : in std_logic_vector(N-1 downto 0);  --A2/RD2
		inp2 : in std_logic_vector(N-1 downto 0); --ExtImm
		Src_o : out std_logic_vector(N-1 downto 0)
	) ;
end mux2to1;

architecture mux2to1_arc of mux2to1 is

begin

	MUX : process( ALUSrc,inp1,inp2)
	begin
		if ALUSrc = '1' then 
			Src_o <= inp2;
		else
			Src_o <= inp1;
		end if;
	end process ; -- MUX

end  mux2to1_arc;