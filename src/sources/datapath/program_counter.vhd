library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               

entity prog_counter  is
	generic (
		N : integer := 32
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		WE : in std_logic;
		PC_i : in std_logic_vector(N-1 downto 0);
		PC_o : out std_logic_vector(N-1 downto 0)
	) ;
end ;

architecture prog_counter_arc of prog_counter is

signal pc_s : std_logic_vector(N-1 downto 0);

begin

READ_PROC : process( clk )
begin
if rising_edge(clk) then
	if rst = '1' then
	 PC_o <= (others => '0');
	else
	 PC_o <= pc_s;
	end if;
end if;	
end process ; -- READ_PROC


WRITE_PROC : process( clk )
begin
if rising_edge(clk) then
	if rst = '1' then
		pc_s <= (others => '0');
	else
		if WE = '1' then 
			pc_s <= PC_i;
		end if;
	end if;
end if;	
end process ; -- WRITE_PROC

end prog_counter_arc;