

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------------------------------------

entity RF_tb is

end entity RF_tb;

-----------------------------------------------------------

architecture testbench of RF_tb is

	-- Testbench DUT generics
	constant N : integer := 4;
	constant M : integer := 32;

	-- Testbench DUT ports
	signal clk : std_logic;
	signal rst : std_logic;
	signal A1  : std_logic_vector(N-1 downto 0);
	signal A2  : std_logic_vector(N-1 downto 0);
	signal A3  : std_logic_vector(N-1 downto 0);
	signal WD3 : std_logic_vector(M-1 downto 0);
	signal WE3 : std_logic;
	signal R15 : std_logic_vector(M-1 downto 0);
	signal RD2 : std_logic_vector(M-1 downto 0);
	signal RD1 : std_logic_vector(M-1 downto 0);

	-- Other constants
	constant C_CLK_PERIOD : time := 10 ns; -- NS

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
		 R15 <= x"000FFFFF";
--When Write is enabled write to RF registers 0 to 7 , the values 1 to 8
		 WE3 <='1';
		 A3  <=X"0";
		 WD3 <= x"00000001"; 
		 wait for 10 ns;
		 A3  <=X"1";
		 WD3 <= x"00000002";
		 wait for 10 ns;
		 A3  <=X"2";
		 WD3 <= x"00000003";
		 wait for 10 ns;
		 A3  <=X"3";
		 WD3 <= x"00000004";
		 wait for 10 ns;
		 A3  <=X"4";
		 WD3 <= x"00000005"; 
		 wait for 10 ns;
		 A3  <=X"5";
		 WD3 <= x"00000006";
		 wait for 10 ns;
		 A3  <=X"6";
		 WD3 <= x"00000007";
		 wait for 10 ns;
		 A3  <=X"7";
		 WD3 <= x"00000008";
		 wait for 10 ns;
		 WE3 <= '0';
--When Write is disabled, read the written registers , 2 by 2
		 A1 <= x"0"; 
		 A2 <= x"1";
		 wait for 10 ns ; 
		 A1 <= x"2"; 
		 A2 <= x"3";
         wait for 10 ns ; 
		 A1 <= x"4"; 
		 A2 <= x"5";
		 wait for 10 ns ; 
		 A1 <= x"6"; 
		 A2 <= x"7";
		 wait for 10 ns; --read the PC
		 A1 <= x"F";
		 A2 <= X"F";
		 wait for 10 ns;

		wait;
	end process STIM;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.RF
		generic map (
			N => N,
			M => M
		)
		port map (
			clk => clk,
			rst => rst,
			A1  => A1,
			A2  => A2,
			A3  => A3,
			WD3 => WD3,
			WE3 => WE3,
			R15 => R15,
			RD2 => RD2,
			RD1 => RD1
		);

end architecture testbench;