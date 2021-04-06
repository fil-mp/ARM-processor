library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use ieee.std_logic_unsigned.all;        -- for addition & counting



entity alu is
	generic (
			N : integer := 32
		);
	port (
		ALUSrcA : in std_logic_vector(N-1 downto 0);
		ALUSrcB : in std_logic_vector(N-1 downto 0);
		ALUControl : in std_logic_vector(2 downto 0);
		ALUResult : out std_logic_vector(N-1 downto 0);
		Neg,Z,O,C : out std_logic
	) ;
end alu;

architecture alu_arc of alu is



constant ADD : std_logic_vector(2 downto 0) := "000"; 
constant SUB : std_logic_vector(2 downto 0) := "001"; 
constant ANDL : std_logic_vector(2 downto 0) := "010";  -- AND
constant EOR : std_logic_vector(2 downto 0) := "011"; --XOR
constant SCRB : std_logic_vector(2 downto 0) := "100"; --pass ScrB 
constant NOTB : std_logic_vector(2 downto 0) := "101"; --not
constant LSL : std_logic_vector(2 downto 0) := "110"; --Left shift
constant LSR : std_logic_vector(2 downto 0) := "111"; --Right Shift


signal out_temp : std_logic_vector(N downto 0);
signal out_reg : std_logic_vector(N-1 downto 0);

signal op1 : std_logic_vector(N downto 0);
signal op2 : std_logic_vector(N downto 0);


begin

--out_reg <= out_temp(N-1 downto 0);
op1 <= ALUSrcA(N-1)&ALUSrcA;
op2 <= ALUSrcB(N-1)&ALUSrcB;


out_temp <= 
		op1 and op2  WHEN ALUControl= ANDL   ELSE 
		op1 xor op2  WHEN ALUControl= EOR    ELSE 
		op1 + op2    WHEN ALUControl= ADD    ELSE 
		op1 - op2    WHEN ALUControl= SUB    ELSE 
		op2          WHEN ALUControl = SCRB  ELSE
		not op2	     WHEN ALUControl = NOTB  ELSE
		std_logic_vector(shift_left(unsigned(op1),to_integer(unsigned(op2))))  WHEN ALUControl= LSL  ELSE --SLL
		std_logic_vector(shift_right(unsigned(op1),to_integer(unsigned(op2))))  WHEN ALUControl= LSR ELSE  --SRL
		(others => '0') ; 
	

Neg <= '1' WHEN signed(out_temp(N-1 downto 0))< 0 ELSE '0' ;  
Z <= '1' WHEN out_temp(N-1 downto 0) = (N-1 downto 0 => '0') ELSE '0';	
O  <=  '1' WHEN out_temp(N) /= out_temp(N-1) else '0';
C <= out_temp(N);


OUTPUT_PROC : process( out_temp )
begin
	if out_temp(N) /= out_temp(N-1) then
		if out_temp(N) = '1' then
			ALUResult <= ('1' , others => '0');
		else
			ALUResult <= ('0' , others => '1');
		end if;
	else
		ALUResult <= out_temp(N-1 downto 0);
	end if;
end process ; 


end  alu_arc;