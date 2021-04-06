
--------------------------------------------------------------------------------
-- Copyright (c) 2020 User Company Name
-------------------------------------------------------------------------------
-- Description: 
--------------------------------------------------------------------------------
-- Revisions:  Revisions and documentation are controlled by
-- the revision control system (RCS).  The RCS should be consulted
-- on revision history.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------------------------------------

entity arm_processor_top_tb is

end entity arm_processor_top_tb;

-----------------------------------------------------------

architecture testbench of arm_processor_top_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk       : std_logic;
	signal rst       : std_logic;
	signal PC        : std_logic_vector(31 downto 0);
	signal instr     : std_logic_vector(31 downto 0);
	signal ALUResult : std_logic_vector(31 downto 0);
	signal WriteData : std_logic_vector(31 downto 0);
	signal Result    : std_logic_vector(31 downto 0);

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
	DUT : entity work.arm_processor_top
		port map (
			clk       => clk,
			rst       => rst,
			PC        => PC,
			instr     => instr,
			ALUResult => ALUResult,
			WriteData => WriteData,
			Result    => Result
		);

end architecture testbench;