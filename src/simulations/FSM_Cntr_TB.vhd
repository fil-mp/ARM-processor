

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------------------------------------

entity FSM_Cntr_tb is

end entity FSM_Cntr_tb;

-----------------------------------------------------------

architecture testbench of FSM_Cntr_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk        : std_logic;
	signal rst        : std_logic;
	signal op         : std_logic_vector(1 downto 0);
	signal S_L        : std_logic;
	signal Rd         : std_logic_vector(3 downto 0);
	signal NoWrite_in : std_logic;
	signal CondEx_in  : std_logic;
	signal PCWrite    : std_logic;
	signal IRWrite    : std_logic;
	signal RegWrite   : std_logic;
	signal FlagsWrite : std_logic;
	signal MAWrite    : std_logic;
	signal MemWrite   : std_logic;
	signal PCSrc      : std_logic;

	-- Other constants
	constant C_CLK_PERIOD : real := 10.0e-9; -- NS

begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clk <= '1';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
		clk <= '0';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
	end process CLK_GEN;

	RESET_GEN : process
	begin
		rst <= '1',
		         '0' after 20.0*C_CLK_PERIOD * (1 SEC);
		wait;
	end process RESET_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.FSM_Cntr
		port map (
			clk        => clk,
			rst        => rst,
			op         => op,
			S_L        => S_L,
			Rd         => Rd,
			NoWrite_in => NoWrite_in,
			CondEx_in  => CondEx_in,
			PCWrite    => PCWrite,
			IRWrite    => IRWrite,
			RegWrite   => RegWrite,
			FlagsWrite => FlagsWrite,
			MAWrite    => MAWrite,
			MemWrite   => MemWrite,
			PCSrc      => PCSrc
		);

end architecture testbench;