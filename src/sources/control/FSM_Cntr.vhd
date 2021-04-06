library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity FSM_Cntr is
	port (
		clk : in std_logic;
		rst : in std_logic;
		op  : in std_logic_vector(1 downto 0);
		S_L : in std_logic;
		Rd  : in std_logic_vector(3 downto 0);
		NoWrite_in	 : in std_logic;
		CondEx_in	 : in std_logic;

		PCWrite 	 : out std_logic;
		IRWrite		 : out std_logic;
		RegWrite	 : out std_logic;
		FlagsWrite	 : out std_logic;
		MAWrite		 : out std_logic;
		MemWrite	 : out std_logic;
		PCSrc		 : out std_logic

	) ;
end FSM_Cntr;

architecture FSM_Cntr_arc of FSM_Cntr is

type state_type is (s0,s1,s2a,s2b,s3,s4a,s4b,s4c,s4d,s4e,s4f,s4g,s4h,s4j);
signal cstate : state_type;


begin


FSM_PROC : process( clk )
begin
	if rising_edge(clk) then
		if rst='1' then
					IRWrite   	<= '1' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '0' ;
					cstate      <=  s0;
		else
			case(cstate) is
				when s0  => 
					IRWrite   	<= '1' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '0' ;

					cstate  <=  s1;

				when s1  => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '0' ;

					if (CondEx_in = '0') then
						cstate  <= s4c ;
					else
						if    (op="01") then
							cstate  <= s2a;

						elsif (op="10") then  --branches
							cstate   <= s4h;

						elsif (op="00") then
							if (NoWrite_in='0') then
								cstate  <= s2b;						
							else
								cstate  <= s4g;
							end if;
						end if;

					end if;


				when s2a => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '1' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '0' ;

					if (S_L = '1') then
						cstate  <= s3;
					else
						cstate  <= s4d;
						
					end if;

				when s2b => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '0' ;

					if Rd = "1111" then 
						if S_L = '1' then
							cstate  <= s4f;
						else
							cstate  <= s4b;
					end if;
					else
						if S_L = '1' then
							cstate  <= s4e;
						else
							cstate  <= s4a;
						end if;
					end if;

				when s3  => --load entolh
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '0' ;

					if Rd="1111" then
						cstate <= s4b;
					else
						cstate  <= s4a;
					end if;

				when s4a => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '1' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '1' ;

					cstate  <=  s0;

				when s4b => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '1' ;
					PCWrite	  	<= '1' ;

					cstate  <=  s0;

				when s4c =>  ---------------------------------------------------PROORO CANCLEL ENTOLHS
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '1' ;

					cstate  <= s0;

				when s4d => ---- store
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '1' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '1' ;

					cstate  <= s0;

				when s4e => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '1' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '1' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '1' ;

					cstate  <=  s0;

				when s4f => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '1' ;
					PCSrc	  	<= '1' ;
					PCWrite	  	<= '1' ;

					cstate  <=  s0;

				when s4g => 
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '1' ;
					PCSrc	  	<= '0' ;
					PCWrite	  	<= '1' ;

					cstate  <=  s0;

				when s4h =>  --------------------------------brancxh-----------------unknown
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '0' ; --01  --pcp8+imm24*4 
					PCWrite	  	<= '0' ;
					cstate  <=  s4j;

				when s4j =>
					IRWrite   	<= '0' ;
					RegWrite  	<= '0' ;
					MAWrite	  	<= '0' ;
					MemWrite  	<= '0' ;
					FlagsWrite	<= '0' ;
					PCSrc	  	<= '1' ; --01  --pcp8+imm24*4 
					PCWrite	  	<= '1' ;
					cstate  <=  s0;

				
				
			end case;
		end if;
	end if;
	
end process ; -- FSM_PROC



end  FSM_Cntr_arc;