library ieee;
use ieee.std_logic_1164.all;--
use ieee.numeric_std.all;               -- for type conversions

entity extend is
	generic (
			N : integer := 32
		);
	port (
		ImmSrc : in std_logic;
		ExtImm : out std_logic_vector(N-1 downto 0);
		Imm : in std_logic_vector(23 downto 0)
	) ;
end extend;

architecture extend_arc of extend is

begin

IMM_PROC : process( ImmSrc ,Imm )
begin
	if ImmSrc = '0' then
		ExtImm <= "00000000000000000000" & Imm(11 downto 0);
	else
		ExtImm <= Imm(23)&Imm(23)&Imm(23)&Imm(23)&Imm(23)&Imm(23)&Imm&"00" ;
	end if;
	
end process ; -- IMM_PROC

end  extend_arc;