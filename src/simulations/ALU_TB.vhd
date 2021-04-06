

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------------------------------------

entity alu_tb is

end entity alu_tb;

-----------------------------------------------------------

architecture testbench of alu_tb is

	-- Testbench DUT generics
	constant N : integer := 32;

	-- Testbench DUT ports
	signal ALUSrcA    : std_logic_vector(N-1 downto 0);
	signal ALUSrcB    : std_logic_vector(N-1 downto 0);
	signal ALUControl : std_logic_vector(2 downto 0);
	signal ALUResult  : std_logic_vector(N-1 downto 0);
	signal Neg,Z,O,C  : std_logic;

	-- Other constants
	constant C_CLK_PERIOD : time := 10 ns; -- NS

	constant ADD : std_logic_vector(2 downto 0) := "000"; 
	constant SUB : std_logic_vector(2 downto 0) := "001"; 
	constant ANDL : std_logic_vector(2 downto 0) := "010";  -- AND
	constant EOR : std_logic_vector(2 downto 0) := "011"; --XOR
	constant SCRB : std_logic_vector(2 downto 0) := "100"; --pass ScrB 
	constant NOTB : std_logic_vector(2 downto 0) := "101"; --not
	constant LSL : std_logic_vector(2 downto 0) := "110"; --Left shift
	constant LSR : std_logic_vector(2 downto 0) := "111"; --Right Shift

begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------

	STIM : process
	begin
		 wait for 5*C_CLK_PERIOD;
		 ALUSrcA <= x"0000005A";
		 ALUSrcB <= x"0000000A";
		 ALUControl  <= ADD;--add 0000005A+0000000A = 00000064
		 wait for 10ns;
		 ALUControl  <= SUB;--sub 0000005A-0000000A = 00000050
		 wait for 10ns;
		 ALUSrcA <= X"00000F19"; 
		 ALUSrcB <= X"00000F06";
		 ALUControl  <= ANDL;-- 00000F19 and 00000F06 = 00000F00
		 wait for 10 ns;
		 ALUControl  <= EOR; -- 00000F19 xor 00000F06 = 0000001F
		 wait for 10 ns;
		 ALUControl  <= SCRB; --00000F06
		 wait for 10 ns;
		 ALUControl  <= NOTB; --FFFFF0F9
		 wait for 10 ns;
		 ALUSrcA <= X"0000008A"; 
		 ALUSrcB <= X"00000002"; 
		 ALUControl  <= LSL; -- LSL 138x4
		 wait for 10 ns;
		 ALUControl  <= LSR; -- LSR 138/4
		 wait for 10 ns;
		 ALUControl <= ADD;
		 ALUSrcA <= x"7FFFFFFF";
		 ALUSrcB <= x"7FFFFFFF";

		wait;
	end process STIM;


	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.alu
		generic map (
			N => N
		)
		port map (
			ALUSrcA    => ALUSrcA,
			ALUSrcB    => ALUSrcB,
			ALUControl => ALUControl,
			ALUResult  => ALUResult,
			Neg        => Neg,
			Z          => Z,
			O          => O,
			C          => C
		);

end architecture testbench;