library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity instruction_memory is
     generic (
            N: integer := 6;
            M: integer := 32
        );
	 port (
	     A : in  std_logic_vector(N-1 downto 0);
         INSTR : out std_logic_vector(M-1 downto 0)
         );
end instruction_memory;

architecture instruction_memory_arc of instruction_memory is
constant regNum : integer := 2**N;
type Imem_array is array (0 to regNum-1)of std_logic_vector(M-1 downto 0);
  constant Imem : Imem_array := (  -- example
    X"E3C00000", X"E3A0100A", X"E1A02001", X"E3E01000", 
    X"E0822001", X"E24230FF", X"E1A11100", X"E5801010", X"E5907010",
    X"EB000003", X"E1A04000", X"E0056001", X"EAFFFFF9", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
    X"00000000", X"00000000", X"00000000", X"00000000",X"00000000");
begin

 INSTR <= Imem(to_integer(unsigned(A)));

end  instruction_memory_arc;


--Move r0 #0
--MVN R1 #0
--add R2,R1,R0
--SUB R3,R2,#255
--MOV RO,RO
--B MAIN_PROGRAM


--constant Imem : Imem_array := (  -- example
--    X"00000000", X"E3C00000", X"E3E01000", X"E2812000", X"E24230FF", 
--    X"E1C00000", X"EAFFFFF9", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
--    X"00000000", X"00000000", X"00000000", X"00000000");