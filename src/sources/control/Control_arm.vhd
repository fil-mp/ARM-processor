library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity Control_arm is
	port (
		clk : in std_logic;
		rst : in std_logic;
		IR : in std_logic_vector(31 downto 0);
		SR : in std_logic_vector(3 downto 0);
		RegSrc	: out std_logic_vector(2 downto 0);
		ALUSrc	: out std_logic;
		MemtoReg	: out std_logic;
		ALUControl	: out std_logic_vector(2 downto 0);
		ImmSrc	: out std_logic;
		IRWrite	: out std_logic;
		RegWrite	: out std_logic;
		MAWrite	: out std_logic;
		MemWrite	: out std_logic;
		FlagsWrite	: out std_logic;
		PCSrc	: out std_logic;
		PCWrite	: out std_logic
	) ;
end Control_arm;

architecture Control_arm_arc of Control_arm is


	component CONDLogic is
		port (
			cond      : in  std_logic_vector(3 downto 0);
			flags     : in  std_logic_vector(3 downto 0);
			CondEx_in : out std_logic
		);
	end component CONDLogic;

	component FSM_Cntr is
		port (
			clk        : in  std_logic;
			rst        : in  std_logic;
			op         : in  std_logic_vector(1 downto 0);
			S_L        : in  std_logic;
			Rd         : in  std_logic_vector(3 downto 0);
			NoWrite_in : in  std_logic;
			CondEx_in  : in  std_logic;
			PCWrite    : out std_logic;
			IRWrite    : out std_logic;
			RegWrite   : out std_logic;
			FlagsWrite : out std_logic;
			MAWrite    : out std_logic;
			MemWrite   : out std_logic;
			PCSrc      : out std_logic
		);
	end component FSM_Cntr;


	component InstrDecoder is
		port (
			op         : in  std_logic_vector(1 downto 0);
			funct      : in  std_logic_vector(5 downto 0);
            shamt_sh   : in std_logic_vector (6 downto 0);
			RegSrc     : out std_logic_vector(2 downto 0);
			ALUSrc     : out std_logic;
			MemtoReg   : out std_logic;
			ALUControl : out std_logic_vector(2 downto 0);
			ImmSrc     : out std_logic;
			NoWrite_in : out std_logic
		);
	end component InstrDecoder;	

signal CondEx_in_s : std_logic;
signal NoWrite_in_s : std_logic;

begin


	CONDLogic1 : entity work.CONDLogic
		port map (
			cond      => IR(31 downto 28),
			flags     => SR,
			CondEx_in => CondEx_in_s
		);	


	FSM_Cntr1 : entity work.FSM_Cntr
		port map (
			clk        => clk,
			rst        => rst,
			op         => IR(27 downto 26),
			S_L        => IR(20),
			Rd         => IR(15 downto 12),
			NoWrite_in => NoWrite_in_s,
			CondEx_in  => CondEx_in_s,
			PCWrite    => PCWrite,
			IRWrite    => IRWrite,
			RegWrite   => RegWrite,
			FlagsWrite => FlagsWrite,
			MAWrite    => MAWrite,
			MemWrite   => MemWrite,
			PCSrc      => PCSrc
		);


	InstrDecoder1 : entity work.InstrDecoder
		port map (
			op         => IR(27 downto 26),
			funct      => IR(25 downto 20),
			shamt_sh   => IR(11 downto 5),
			RegSrc     => RegSrc,
			ALUSrc     => ALUSrc,
			MemtoReg   => MemtoReg,
			ALUControl => ALUControl,
			ImmSrc     => ImmSrc,
			NoWrite_in => NoWrite_in_s
		);		


end  Control_arm_arc;