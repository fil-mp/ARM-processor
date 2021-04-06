library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;       -- for addition & counting
use ieee.numeric_std.all;              -- for type conversions

entity status_register is
	generic (
			N : integer := 4
		);
	port (
		clk : in std_logic;
		rst : in std_logic;
		we : in std_logic;
		NegF,Z,C,V : in std_logic;
		sr_out : out std_logic_vector(N-1 downto 0)  --Flags  N Z C V
	) ;
end status_register;

architecture status_register_arc of status_register is

signal sr_reg : std_logic_vector(N-1 downto 0);
begin

sr_reg <= NegF & Z & C & V ;
DFF : process( clk  )
begin
if rising_edge(clk) then 
	if rst = '1' then 
		sr_out <= (others => '0');
	elsif we = '1' then 
			sr_out <= sr_reg;
	end if;
			--sr_out <= sr_reg;
end if;
end process ; -- DFF



end  status_register_arc;