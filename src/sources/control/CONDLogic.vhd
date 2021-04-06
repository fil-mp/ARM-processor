library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;         -- for addition & counting
use ieee.numeric_std.all;                -- for type conversions

entity CONDLogic is
	port (
		cond : in std_logic_vector(3 downto 0);
		flags : in std_logic_vector(3 downto 0);
		CondEx_in : out std_logic
	) ;
end CONDLogic;

architecture CONDLogic_arc of CONDLogic is


	constant EQ : std_logic_vector(3 downto 0) := "0000"; 
	constant NE : std_logic_vector(3 downto 0) := "0001"; 
	constant CS_HS : std_logic_vector(3 downto 0) := "0010"; 
	constant CC_LO : std_logic_vector(3 downto 0) := "0011"; 
	constant MI : std_logic_vector(3 downto 0) := "0100"; 
	constant PL : std_logic_vector(3 downto 0) := "0101"; 
	constant VS : std_logic_vector(3 downto 0) := "0110"; 
	constant VC : std_logic_vector(3 downto 0) := "0111";

	
	constant HI : std_logic_vector(3 downto 0) := "1000"; 
	constant LS : std_logic_vector(3 downto 0) := "1001"; 
	constant GE : std_logic_vector(3 downto 0) := "1010"; 
	constant LT : std_logic_vector(3 downto 0) := "1011"; 
	constant GT : std_logic_vector(3 downto 0) := "1100"; 
	constant LE : std_logic_vector(3 downto 0) := "1101"; 
	constant AL : std_logic_vector(3 downto 0) := "1110"; 
	constant none : std_logic_vector(3 downto 0) := "1111";
	 
begin

	--flag(o) = N
	--		1  Z
	-- 		2  C
	-- 		3  V

	CONDEX_PRO : process( cond , flags )
	begin
		case(cond) is
			when EQ   => 
				CondEx_in <= flags(1);
			when NE   => 
				CondEx_in <= not flags(1);
			when CS_HS => 
				CondEx_in <= flags(2);
			when CC_LO => 
				CondEx_in <= not flags(2);
			when MI   => 
				CondEx_in <= flags(0);
			when PL   => 
				CondEx_in <= not flags(0);
			when VS   => 
				CondEx_in <= flags(3);
			when VC  => 
				CondEx_in <= not flags(3);

			when  HI  => 
				CondEx_in <= not flags(1) and flags(2);
			when  LS  => 
				CondEx_in <= flags(1) or not flags(2);
			when  GE  => 
				CondEx_in <= not (flags(0) xor flags(3));
			when  LT  => 
				CondEx_in <= flags(0) xor flags(3);
			when  GT  => 
				CondEx_in <= not flags(1) and not (flags(0) xor flags(3));
			when  LE  => 
				CondEx_in <= flags(1) or (flags(0) xor flags(3));
			when  AL  => 
				CondEx_in <= '1';
			when  none => 
				CondEx_in <= '1';

		   when others =>
				CondEx_in  <=  '0';
		end case;
	end process ; -- CONDEX_PRO

end  CONDLogic_arc;














