library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity arm_processor_top is
	port (
		clk : in std_logic;
		rst : in std_logic;
		PC  : out std_logic_vector(31 downto 0);
		instr : out std_logic_vector(31 downto 0);
		ALUResult : out std_logic_vector(31 downto 0);
		WriteData : out std_logic_vector(31 downto 0);
		Result	 : out std_logic_vector(31 downto 0)

	) ;
end arm_processor_top;

architecture arm_processor_top_arc of arm_processor_top is
	component Control_arm is
		port (
			clk        : in  std_logic;
			rst        : in  std_logic;
			IR         : in  std_logic_vector(31 downto 0);
			SR         : in  std_logic_vector(3 downto 0);
			RegSrc     : out std_logic_vector(2 downto 0);
			ALUSrc     : out std_logic;
			MemtoReg   : out std_logic;
			ALUControl : out std_logic_vector(2 downto 0);
			ImmSrc     : out std_logic;
			IRWrite    : out std_logic;
			RegWrite   : out std_logic;
			MAWrite    : out std_logic;
			MemWrite   : out std_logic;
			FlagsWrite : out std_logic;
			PCSrc      : out std_logic;
			PCWrite    : out std_logic
		);
	end component Control_arm;

	component datapath_struct is
		generic (
			N : integer := 6;
			M : integer := 32;
			K : integer := 4;
			L : integer := 5
		);
		port (
			clk        : in  std_logic;
			rst        : in  std_logic;
			PCWrite    : in  std_logic;
			PCSrc      : in  std_logic;
			IRWrite    : in  std_logic;
			RegWrite   : in  std_logic;
			RegSrc     : in  std_logic_vector(2 downto 0);
			ImmSrc     : in  std_logic;
			ALUSrc1     : in  std_logic;
			ALUControl : in  std_logic_vector(2 downto 0);
			FlagsWrite : in  std_logic;
			Flags      : out std_logic_vector(3 downto 0);
			Instuction : out std_logic_vector(31 downto 0);
			MAWrite    : in  std_logic;
			MemWrite   : in  std_logic;
			MemtoReg   : in  std_logic;
			WriteData_o : out std_logic_vector(31 downto 0);
   			ALUResult_o	: out std_logic_vector(31 downto 0);
   			PC_out      : out std_logic_vector(31 downto 0);
   			Result_o	: out std_logic_vector(31 downto 0)
		);
	end component datapath_struct;

	
	signal IR_s         : std_logic_vector(31 downto 0);
	signal SR_s         : std_logic_vector(3 downto 0);
	signal RegSrc_s     : std_logic_vector(2 downto 0);
	signal ALUSrc_s     : std_logic;
	signal MemtoReg_s   : std_logic;
	signal ALUControl_s : std_logic_vector(2 downto 0);
	signal ImmSrc_s     : std_logic;
	signal IRWrite_s    : std_logic;
	signal RegWrite_s   : std_logic;
	signal MAWrite_s    : std_logic;
	signal MemWrite_s   : std_logic;
	signal FlagsWrite_s : std_logic;
	signal PCSrc_s      : std_logic;
	signal PCWrite_s    : std_logic;
	signal Flag_s 		: std_logic_vector(3 downto 0);
	signal intr_s 		: std_logic_vector(31 downto 0);

begin

	
instr <= intr_s;

	Control_arm_1 : entity work.Control_arm
		port map (
			clk        => clk,
			rst        => rst,
			IR         => intr_s,
			SR         => Flag_s,
			RegSrc     => RegSrc_s,
			ALUSrc     => ALUSrc_s,
			MemtoReg   => MemtoReg_s,
			ALUControl => ALUControl_s,
			ImmSrc     => ImmSrc_s,
			IRWrite    => IRWrite_s,
			RegWrite   => RegWrite_s,
			MAWrite    => MAWrite_s,
			MemWrite   => MemWrite_s,
			FlagsWrite => FlagsWrite_s,
			PCSrc      => PCSrc_s,
			PCWrite    => PCWrite_s
		);	


	datapath : entity work.datapath_struct
		generic map (
			N => 6,
			M => 32,
			K => 4,
			L => 5
		)
		port map (
			clk        => clk,
			rst        => rst,
			PCWrite    => PCWrite_s,
			PCSrc      => PCSrc_s,
			IRWrite    => IRWrite_s,
			RegWrite   => RegWrite_s,
			RegSrc     => RegSrc_s,
			ImmSrc     => ImmSrc_s,
			ALUSrc1     => ALUSrc_s,
			ALUControl => ALUControl_s,
			FlagsWrite => FlagsWrite_s,
			Flags      => Flag_s,
			Instuction => intr_s,
			MAWrite    => MAWrite_s,
			MemWrite   => MemWrite_s,
			MemtoReg   => MemtoReg_s,
			WriteData_o  => WriteData,
   			ALUResult_o	 => ALUResult,
   			PC_out       => PC,
   			Result_o	 => Result
   		);
end  arm_processor_top_arc;