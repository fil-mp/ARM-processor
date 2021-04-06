library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity InstrDecoder is
	port (
		op 	  : in std_logic_vector(1 downto 0);
		funct : in std_logic_vector(5 downto 0);
		shamt_sh : in STD_LOGIC_VECTOR (6 downto 0);
		RegSrc : out std_logic_vector(2 downto 0);
		ALUSrc : out std_logic;
		MemtoReg : out std_logic;
		ALUControl : out  std_logic_vector(2 downto 0); 
		ImmSrc		: out std_logic;
		NoWrite_in	: out std_logic
	) ;
end InstrDecoder;

architecture InstrDecoder_arc of InstrDecoder is



constant DP : std_logic_vector(1 downto 0) := "00"; 
constant MEM : std_logic_vector(1 downto 0) := "01"; 
constant BR : std_logic_vector(1 downto 0) := "10"; 


constant MOVR_LSL_LSR   : std_logic_vector(5 downto 0) := "011010";  


constant ADD_R : std_logic_vector(5 downto 0) := "00100X"; 
constant SUB_R : std_logic_vector(5 downto 0) := "00010X"; 
constant AND_R : std_logic_vector(5 downto 0) := "00000X"; 
constant XOR_R : std_logic_vector(5 downto 0) := "00001X"; 
constant CMP_R : std_logic_vector(5 downto 0) := "011101";  
constant MVN_R : std_logic_vector(5 downto 0) := "011110"; 


--Immediate
constant ADD_I : std_logic_vector(5 downto 0) := "10100X"; 
constant SUB_I : std_logic_vector(5 downto 0) := "10010X"; 
constant AND_I : std_logic_vector(5 downto 0) := "10000X"; 
constant XOR_I : std_logic_vector(5 downto 0) := "10001X"; --
constant CMP_I : std_logic_vector(5 downto 0) := "111101"; 
constant MOV_I : std_logic_vector(5 downto 0) := "111100"; 
constant MVN_I : std_logic_vector(5 downto 0) := "111110"; 



constant LDR 	: std_logic_vector(5 downto 0) := "011001"; 
constant LDR_S  : std_logic_vector(5 downto 0) := "010001"; 
constant STR 	: std_logic_vector(5 downto 0) := "011000"; 
constant STR_S  : std_logic_vector(5 downto 0) := "010000"; 

constant B 	: std_logic_vector(5 downto 0) := "10XXXX"; 
constant BL 	: std_logic_vector(5 downto 0) := "11XXXX"; 




begin


	DECPro : process( OP,funct, shamt_sh )
	begin
		case(OP) is
			when DP => 
					if funct(5 downto 1) = ADD_R(5 downto 1)  then  --
						RegSrc 		<= "000";
						ALUSrc		<= '0';
						ImmSrc		<= 'X';
						ALUControl	<= "000";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct(5 downto 1) = SUB_R(5 downto 1)  then --
						RegSrc 		<= "000";
						ALUSrc		<= '1';
						ImmSrc		<= 'X';
						ALUControl	<= "001";
						MemtoReg	<= '0';
						NoWrite_in	<= '0'; 
					elsif funct(5 downto 1) = AND_R(5 downto 1)  then --
						RegSrc 		<= "000";
						ALUSrc		<= '0';
						ImmSrc		<= 'X';
						ALUControl	<= "010";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct(5 downto 1) = XOR_R(5 downto 1)  then  --
						RegSrc 		<= "000";
						ALUSrc		<= '0';
						ImmSrc		<= 'X';
						ALUControl	<= "011";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct = CMP_R  then  --
						RegSrc 		<= "000";
						ALUSrc		<= '0';
						ImmSrc		<= 'X';
						ALUControl	<= "001";
						MemtoReg	<= 'X';
						NoWrite_in	<= '1';
	
					elsif funct = MVN_R  then  --
						RegSrc 		<= "00X";
						ALUSrc		<= '0';
						ImmSrc		<= 'X';
						ALUControl	<= "101"; 
						MemtoReg	<= '0';
						NoWrite_in	<= '0';

					elsif funct(5 downto 1) = ADD_I(5 downto 1)  then 
						RegSrc 		<= "0X0";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "000";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct(5 downto 1) = SUB_I(5 downto 1)  then 
						RegSrc 		<= "0X0";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "001";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct(5 downto 1) = AND_I(5 downto 1)  then  --
						RegSrc 		<= "0X0";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "010";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct(5 downto 1) = XOR_I(5 downto 1)  then 
						RegSrc 		<= "0X0";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "000";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct = CMP_I  then 
						RegSrc 		<= "0X0";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "001";
						MemtoReg	<= 'X';
						NoWrite_in	<= '1';
					elsif funct = MOV_I  then 
						RegSrc 		<= "0XX";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "100";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct = MVN_I  then 
						RegSrc 		<= "0XX";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "101";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';

					elsif funct = MOVR_LSL_LSR  then
					    if(shamt_sh = "0000000") then --MOV reg
                            RegSrc <= "00X";
                            ALUSrc <= '0';
                            ImmSrc <= 'X';
                            ALUControl <= "100";
                            MemtoReg <= '0';
                            NoWrite_in <= '0';
                        elsif((shamt_sh(1 downto 0) = "00")) then -- LSL
                            RegSrc <= "000";
                            ALUSrc <= '1';
                            ImmSrc <= '0';
                            ALUControl <= "110";
                            MemtoReg <= '0';
                            NoWrite_in <= '0';
                        elsif((shamt_sh(1 downto 0) = "10")) then -- LSR
                            RegSrc <= "000";
                            ALUSrc <= '1';
                            ImmSrc <= '0';
                            ALUControl <= "111";
                            MemtoReg <= '0';
                            NoWrite_in <= '0';
                        else
                            RegSrc <= "000";
                            ALUSrc <= '0';
                            ImmSrc <= '0';
                            ALUControl <= "000";
                            MemtoReg <= '0';
                            NoWrite_in <= '0';
                        end if;
					end if;	
								


			when MEM =>
					if funct =  LDR    then 
						RegSrc 		<= "0X0";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "000"; --add
						MemtoReg	<= '1';
						NoWrite_in	<= '0';
					elsif funct =  LDR_S  then 
						RegSrc 		<= "0X0";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "001"; --sub
						MemtoReg	<= '1';
						NoWrite_in	<= '0';
					elsif funct =  STR    then 
						RegSrc 		<= "010";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "000";
						MemtoReg	<= 'X';
						NoWrite_in	<= '0';
					elsif funct =  STR_S  then 
						RegSrc 		<= "010";
						ALUSrc		<= '1';
						ImmSrc		<= '0';
						ALUControl	<= "001";
						MemtoReg	<= 'X';
						NoWrite_in	<= '0';
					else
					    RegSrc 		<= "XXX";
						ALUSrc		<= 'X';
						ImmSrc		<= 'X';
						ALUControl	<= "XXX";
						MemtoReg	<= 'X';
						NoWrite_in	<= 'X';
					end if;
									
			when BR =>
					if funct(5 downto 4) = B(5 downto 4)   then  
						RegSrc 		<= "0X1";
						ALUSrc		<= '1';
						ImmSrc		<= '1';
						ALUControl	<= "000";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					elsif funct(5 downto 4) = BL(5 downto 4)  then  
						RegSrc 		<= "1X1";
						ALUSrc		<= '1';
						ImmSrc		<= '1';
						ALUControl	<= "000";
						MemtoReg	<= '0';
						NoWrite_in	<= '0';
					else
					    RegSrc 		<= "XXX";
						ALUSrc		<= 'X';
						ImmSrc		<= 'X';
						ALUControl	<= "XXX";
						MemtoReg	<= 'X';
						NoWrite_in	<= 'X';
					end if;
			when others => 
			 		    RegSrc 		<= "XXX";
						ALUSrc		<= 'X';
						ImmSrc		<= 'X';
						ALUControl	<= "XXX";
						MemtoReg	<= 'X';
						NoWrite_in	<= 'X';
			
		end case;
		
	end process ; -- TEST

end  InstrDecoder_arc;

