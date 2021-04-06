

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------------------------------------

entity Control_arm_tb is

end entity Control_arm_tb;

-----------------------------------------------------------

architecture testbench of Control_arm_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk        : std_logic;
	signal rst        : std_logic;
	signal IR         : std_logic_vector(31 downto 0);
	signal SR         : std_logic_vector(3 downto 0);
	signal RegSrc     : std_logic_vector(2 downto 0);
	signal ALUSrc     : std_logic;
	signal MemtoReg   : std_logic;
	signal ALUControl : std_logic_vector(2 downto 0);
	signal ImmSrc     : std_logic;
	signal IRWrite    : std_logic;
	signal RegWrite   : std_logic;
	signal MAWrite    : std_logic;
	signal MemWrite   : std_logic;
	signal FlagsWrite : std_logic;
	signal PCSrc      : std_logic;
	signal PCWrite    : std_logic;

	-- Other constants
	constant C_CLK_PERIOD : time := 10 ns; -- NS

	--conditions
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

	--op
	constant DP : std_logic_vector(1 downto 0) := "00"; 
	constant MEM : std_logic_vector(1 downto 0) := "01"; 
	constant BR : std_logic_vector(1 downto 0) := "10"; 

	--funct
	constant LSL   : std_logic_vector(5 downto 0) := "011010";  --shamt 00
	constant LSR   : std_logic_vector(5 downto 0) := "010010";   -- typicaly has the same funct as LSL must fix ..shamt 01
	constant ADD_R : std_logic_vector(5 downto 0) := "001000"; 
	constant SUB_R : std_logic_vector(5 downto 0) := "000100"; 
	constant AND_R : std_logic_vector(5 downto 0) := "000000"; 
	constant XOR_R : std_logic_vector(5 downto 0) := "000010"; --
	constant CMP_R : std_logic_vector(5 downto 0) := "011101"; 
	constant MOV_R : std_logic_vector(5 downto 0) := "011100"; 
	constant MVN_R : std_logic_vector(5 downto 0) := "011110"; 
	constant ADD_I : std_logic_vector(5 downto 0) := "101000"; 
	constant SUB_I : std_logic_vector(5 downto 0) := "10010X"; 
	constant AND_I : std_logic_vector(5 downto 0) := "100000"; -------------------
	constant XOR_I : std_logic_vector(5 downto 0) := "10001X"; --
	constant CMP_I : std_logic_vector(5 downto 0) := "111101"; 
	constant MOV_I : std_logic_vector(5 downto 0) := "111100"; 
	constant MVN_I : std_logic_vector(5 downto 0) := "111110"; 
	constant LDR 	: std_logic_vector(5 downto 0) := "011001"; 
	constant LDR_S  : std_logic_vector(5 downto 0) := "010001"; 
	constant STR 	: std_logic_vector(5 downto 0) := "011000"; 
	constant STR_S  : std_logic_vector(5 downto 0) := "010000"; 
	constant B 	: std_logic_vector(5 downto 0)     := "10XXXX"; 
	constant BL 	: std_logic_vector(5 downto 0) := "11XXXX"; 




begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clk <= '1';
		wait for C_CLK_PERIOD / 2 ;
		clk <= '0';
		wait for C_CLK_PERIOD / 2;
	end process CLK_GEN;

	STIM : process
	begin
		 rst <= '1';
		 wait for 5*C_CLK_PERIOD;
		 rst <= '0';
		 SR  <= (others => '0');
		 IR  <= none&MEM&LDR&x"00000";
		 wait for 5*C_CLK_PERIOD;
		 IR  <= none&MEM&STR&x"00000";
		 wait for 4*C_CLK_PERIOD;
		 IR <= none&DP&ADD_R(5 downto 1)&'0'&x"00000"; 
		  wait for 4*C_CLK_PERIOD;
		 IR <= none&DP&ADD_R(5 downto 1)&'1'&x"00000"; 
		 wait for 4*C_CLK_PERIOD;
		 IR <= none &BR &B(5 downto 4)&"0000"&x"00000";
		 wait for 4*C_CLK_PERIOD;
		 IR <= none&DP&LSL&x"00000"; 
		 wait for 4*C_CLK_PERIOD;
		 IR <= EQ&DP&LSL&x"00000"; --with NE condition must not satisfy

	   




		 wait for 3*C_CLK_PERIOD;
		 IR  <= (others => '0');
		 rst  <= '1';

		
		 

		wait;
	end process STIM;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.Control_arm
		port map (
			clk        => clk,
			rst        => rst,
			IR         => IR,
			SR         => SR,
			RegSrc     => RegSrc,
			ALUSrc     => ALUSrc,
			MemtoReg   => MemtoReg,
			ALUControl => ALUControl,
			ImmSrc     => ImmSrc,
			IRWrite    => IRWrite,
			RegWrite   => RegWrite,
			MAWrite    => MAWrite,
			MemWrite   => MemWrite,
			FlagsWrite => FlagsWrite,
			PCSrc      => PCSrc,
			PCWrite    => PCWrite
		);

end architecture testbench;