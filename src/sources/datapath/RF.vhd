library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;              -- for type conversions
use IEEE.math_real.all;
entity RF is
	generic (
			N : integer := 4;
			M : integer := 32
		);
	port (
		clk : in std_logic;
		rst : in std_logic;
		A1 : in std_logic_vector(N-1 downto 0);
		A2 : in std_logic_vector(N-1 downto 0);
		A3 : in std_logic_vector(N-1 downto 0);
		WD3 : in std_logic_vector(M-1 downto 0);
		WE3 : in std_logic;
		R15 : in std_logic_vector(M-1 downto 0);
		RD2 : out std_logic_vector(M-1 downto 0);
		RD1 : out std_logic_vector(M-1 downto 0)
	) ;
end RF;

architecture RF_arc of RF is


constant regNum : integer := 2**N;
type ram_type is array (regNum-2 downto 0) of std_logic_vector (M-1 downto 0);
signal RAM     : ram_type := ((others => (others => '0')));
signal addr_in : std_logic_vector(N-1 downto 0); 


begin


RF_PROC : process(clk)
begin
    if rising_edge(clk) then
        if (WE3 = '1') then
            RAM(to_integer(unsigned(A3))) <= WD3;
        end if;
    end if;
end process;
RD1 <= RAM(to_integer(unsigned(A1))) when A1 /= "1111" else R15;
RD2 <= RAM(to_integer(unsigned(A2))) when A2 /= "1111" else R15;

end  RF_arc;

