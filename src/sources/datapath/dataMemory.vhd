library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;              -- for type conversions
use IEEE.math_real.all;
entity DataMemory is
	generic (
			N : integer := 5;
			M : integer := 32
		);
	port (
		clk : in std_logic;
		rst : in std_logic;
		A : in std_logic_vector(N-1 downto 0);
		WD : in std_logic_vector(M-1 downto 0);
		MemWrite: in std_logic;
		RD : out std_logic_vector(M-1 downto 0)
	) ;
end DataMemory;

architecture DataMemory_arc of DataMemory is


constant regNum : integer := 2**N;
type ram_type is array (regNum-2 downto 0) of std_logic_vector (M-1 downto 0);
signal RAM     : ram_type := ((others => (others => '0')));
signal addr_in : std_logic_vector(N-1 downto 0); 


begin


dataMemory_PROC : process(clk)
begin
    if rising_edge(clk) then
        if (MemWrite = '1') then
            RAM(to_integer(unsigned(A))) <= WD;
        end if;
    end if;
end process;
RD <= RAM(to_integer(unsigned(A)));

end  DataMemory_arc;