
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions



entity datapath_struct is
	generic (
			N : integer := 6;
			M: integer := 32;
			K : integer := 4;
			L : integer := 5
		);
   Port ( 
   		clk : in std_logic;
   		rst : in std_logic;
   		PCWrite : in std_logic;
   		PCSrc 	: in std_logic;
   		IRWrite : in std_logic;
   		RegWrite : in std_logic;
   		RegSrc : in  std_logic_vector(2 downto 0);
   		ImmSrc : in std_logic;
   		ALUSrc1 : in std_logic;
   		ALUControl : in std_logic_vector(2 downto 0);
   		FlagsWrite : in std_logic;
   		Flags : out std_logic_vector(3 downto 0);
   		Instuction : out std_logic_vector(31 downto 0);
   		MAWrite : in std_logic;
   		MemWrite : in std_logic;
   		MemtoReg : in std_logic;
   		WriteData_o : out std_logic_vector(31 downto 0);
   		ALUResult_o	: out std_logic_vector(31 downto 0);
   		PC_out : out std_logic_vector(31 downto 0);
   		Result_o : out std_logic_vector(31 downto 0)
   		);
end datapath_struct;

architecture Behavioral of datapath_struct is


--------------------------------------------------------------------------------
--Step one ---------------------------------------------------------------------
	component instruction_memory is
		generic (
			N : integer := 6;
			M : integer := 32
		);
		port (
			A     : in  std_logic_vector(N-1 downto 0);
			INSTR : out std_logic_vector(M-1 downto 0)
		);
	end component instruction_memory;

	component inc4 is
		generic (
			N : integer := 32
		);
		port (
			p4_in  : in std_logic_vector(N-1 downto 0);
			p4_out : out std_logic_vector(N-1 downto 0)
		);
	end component inc4;

	component prog_counter is
		generic (
			N : integer := 32
		);
		port (
			clk  : in  std_logic;
			rst  : in  std_logic;
			WE   : in  std_logic;
			PC_i : in  std_logic_vector(N-1 downto 0);
			PC_o : out std_logic_vector(N-1 downto 0)
		);
	end component prog_counter;


--------------------------------------------------------------------------------
------------------------step 2-----------------------------------------------
	component extend is
		generic (
			N : integer := 32
		);
		port (
			ImmSrc : in  std_logic;
			ExtImm : out std_logic_vector(N downto 0);
			Imm    : in  std_logic_vector(23 downto 0)
		);
	end component extend;


	component RF is
		generic (
			N : integer := 4;
			M : integer := 32
		);
		port (
			clk : in  std_logic;
			rst : in  std_logic;
			A1  : in  std_logic_vector(N-1 downto 0);
			A2  : in  std_logic_vector(N-1 downto 0);
			A3  : in  std_logic_vector(N-1 downto 0);
			WD3 : in  std_logic_vector(M-1 downto 0);
			WE3 : in  std_logic;
			R15 : in  std_logic_vector(M-1 downto 0);
			RD2 : out std_logic_vector(M-1 downto 0);
			RD1 : out std_logic_vector(M-1 downto 0)
		);
	end component RF;

	component alu is
		generic (
			N : integer := 32
		);
		port (
			ALUSrcA    : in  std_logic_vector(N-1 downto 0);
			ALUSrcB    : in  std_logic_vector(N-1 downto 0);
			ALUControl : in  std_logic_vector(2 downto 0);
			ALUResult  : out std_logic_vector(N-1 downto 0);
			Neg,Z,O,C  : out std_logic
		);
	end component alu;	

	component status_register is
		generic (
			N : integer := 4
		);
		port (
			clk        : in  std_logic;
			rst        : in  std_logic;
			we         : in  std_logic;
			NegF,Z,C,V : in  std_logic;
			sr_out     : out std_logic_vector(N-1 downto 0)
		);
	end component status_register;


	component mux2to1 is
		generic (
			N : integer 
		);
		port (
			ALUSrc : in  std_logic;
			inp1   : in  std_logic_vector(N-1 downto 0);
			inp2   : in  std_logic_vector(N-1 downto 0);
			SrcB_o : out std_logic_vector(N-1 downto 0)
		);
	end component mux2to1;	

	component dataMemory is
		generic (
			N : integer := 5;
			M : integer := 32
		);
		port (
			clk      : in  std_logic;
			rst      : in  std_logic;
			A        : in  std_logic_vector(N-1 downto 0);
			WD       : in  std_logic_vector(M-1 downto 0);
			MemWrite : in  std_logic;
			RD       : out std_logic_vector(M-1 downto 0)
		);
	end component dataMemory;

	component muxp4 is
		generic (
			N : integer := 32
		);
		port (
			ctr    : in  std_logic;
			i_act1 : in  std_logic_vector(N-1 downto 0);
			i_act0 : in  std_logic_vector(N-1 downto 0);
			o_mux  : out std_logic_vector(N-1 downto 0)
		);
	end component muxp4;

signal ir_s : std_logic_vector(M-1 downto 0);

signal PCN_s       	: std_logic_vector(M-1 downto 0);
signal PC_s        	: std_logic_vector(M-1 downto 0);
signal PCPlus4_s    : std_logic_vector(M-1 downto 0);
signal inst_s      	: std_logic_vector(M-1 downto 0);
signal IR       	: std_logic_vector(M-1 downto 0);
signal PCp4       	: std_logic_vector(M-1 downto 0);

signal RA1       	: std_logic_vector(3 downto 0);
signal RA2       	: std_logic_vector(3 downto 0);
signal WA        	: std_logic_vector(3 downto 0);
signal WD3_s       	: std_logic_vector(31 downto 0);
signal PCplus8      : std_logic_vector(31 downto 0);
signal RD2_s       	:std_logic_vector(31 downto 0);
signal RD1_s       	:std_logic_vector(31 downto 0);
signal ExtImm_s     : std_logic_vector(31 downto 0);

signal I_s       	: std_logic_vector(31 downto 0);
signal A_s       	: std_logic_vector(31 downto 0);
signal B_s       	: std_logic_vector(31 downto 0);
signal WriteData    : std_logic_vector(31 downto 0);
signal ALUSrcB_s    : std_logic_vector(31 downto 0);
signal nf_s       	: std_logic;
signal zf_s	      	: std_logic;
signal cf_s	      	: std_logic;
signal Vf_s	      	: std_logic;
signal ALUResult_s  : std_logic_vector(31 downto 0);
signal RD_s       	: std_logic_vector(31 downto 0);
signal MA_s       	: std_logic_vector(31 downto 0);
signal WD_s       	: std_logic_vector(31 downto 0);
signal S_s        	: std_logic_vector(31 downto 0);
signal RD_z       	: std_logic_vector(31 downto 0);
signal Result       : std_logic_vector(31 downto 0);
constant mux15      : std_logic_vector(3 downto 0) := "1111";
constant mux14      : std_logic_vector(3 downto 0) := "1110";
---------------------------------------------------------------------------------

begin


----------------------Step 1---------------------------------------------

	instruction_memory1 : entity work.instruction_memory
		generic map (
			N => N,
			M => M
		)
		port map (
			A     => PC_s(N+1 downto 2), --
			INSTR => inst_s
		);

	inc4_1 : entity work.inc4
		generic map (
			N => M
		)
		port map (
			p4_in  => PC_s,
			p4_out => PCPlus4_s
		);

	program_counter : entity work.prog_counter
		generic map (
			N => M
		)
		port map (
			clk  => clk,
			rst  => rst,
			WE   => PCWrite,
			PC_i => PCN_s, --p5
			PC_o => PC_s
		);		

		PC_out  <=  PC_s;
	pipeline_step1 : process( clk )
	begin
		if rising_edge(clk) then 
			if rst = '1' then 
				IR <= (others => '0');
				PCp4 <= (others => '0');
				--Instuction  <= (others => '0');
			else
				if IRWrite = '1' then 
					IR <= inst_s;
					--Instuction <= inst_s;
				end if;
					PCp4 <= PCPlus4_s;
			end if;
		end if;
		
	end process ; -- pipeline_step1
Instuction <= IR;
--------------------------------------------------------------------------------
-------------------------STEP 2------------------------------------------------
	extend_1 : entity work.extend
		generic map (
			N => M
		)
		port map (
			ImmSrc => ImmSrc,
			ExtImm => ExtImm_s,
			Imm    => IR(23 downto 0)
		);	
	

	mux2to1_1 : entity work.mux2to1
		generic map (
			N => K
		)
		port map (
			ALUSrc => RegSrc(1), --i
			inp1   => IR(3 downto 0),
			inp2   => IR(15 downto 12),
			Src_o => RA2
		);


		mux2to1_const1 : entity work.mux2to1
		generic map (
			N => K
		)
		port map (
			ALUSrc => RegSrc(0), --i
			inp1   => IR(19 downto 16),
			inp2   => mux15,
			Src_o => RA1
		);
		
	mux2to1_const2 : entity work.mux2to1
		generic map (
			N => K
		)
		port map (
			ALUSrc => RegSrc(2), --i
			inp1   => IR(15 downto 12),
			inp2   => mux14,
			Src_o => WA
		);



	RF_1 : entity work.RF
		generic map (
			N => K,
			M => M
		)
		port map (
			clk => clk,
			rst => rst,
			A1  => RA1,
			A2  => RA2,
			A3  => WA,
			WD3 => WD3_s, --step5
			WE3 => RegWrite,
			R15 => PCplus8,
			RD2 => RD2_s,
			RD1 => RD1_s
		);	

	pcplus8_1 : entity work.inc4
		generic map (
			N => M
		)
		port map (
			p4_in  => PCp4,
			p4_out => PCplus8
		);


pipeline_step2 : process( clk )
	begin
		if rising_edge(clk) then 
			if rst = '1' then 
				I_s <= (others => '0');
				A_s <=(others => '0');
				B_s <= (others => '0');				
			else
				I_s <= ExtImm_s;
				B_s <= RD2_s;
				A_s <= RD1_s;

			end if;
		end if;
		
	end process ; -- pipeline_step1

		
--------------------------------------------------------------------------------
--step3

WriteData <= B_s;
WriteData_o <= WriteData; --output

	status_register_1 : entity work.status_register
		generic map (
			N => K
		)
		port map (
			clk    => clk,
			rst    => rst,
			we     => FlagsWrite,
			NegF    =>nf_s,
			Z      =>zf_s,
			C      =>cf_s,
			V      =>Vf_s,
			sr_out => Flags
		);

alu_1 : entity work.alu
		generic map (
			N => M
		)
		port map (
			ALUSrcA    => A_s,
			ALUSrcB    => ALUSrcB_s,
			ALUControl => ALUControl,
			ALUResult  => ALUResult_s,
			Neg        => nf_s,
			Z          => zf_s,
			O          => Vf_s,
			C          => cf_s
		);

	mux2to1_2 : entity work.mux2to1
		generic map (
			N => M
		)
		port map (
			ALUSrc => ALUSrc1, --i
			inp1   => WriteData,
			inp2   => I_s,
			Src_o => ALUSrcB_s
		);

pipeline_step3 : process( clk )
	begin
		if rising_edge(clk) then 
			if rst = '1' then 
				MA_s <= (others => '0');
				WD_s <=(others => '0');
				S_s <= (others => '0');
				RD_z <= (others => '0');
			else
				if MAWrite = '1' then 
					MA_s  <= ALUResult_s ;
				end if;
				WD_s <= WriteData;
				S_s <= ALUResult_s;
				ALUResult_o <= ALUResult_s; --output
				RD_z <= RD_s;
			end if;
		end if;
		
	end process ; -- pipeline_step1




	DataMemory_1 : entity work.DataMemory
		generic map (
			N => L,
			M => M
		)
		port map (
			clk      => clk,
			rst      => rst,
			A        => MA_s(L-1 downto 0),
			WD       => WD_s,
			MemWrite => MemWrite,
			RD       => RD_s
		);

--------------------------------------------------------------------------------
--p5

Result_o <= Result;
	muxp4_mreg : entity work.muxp4
		generic map (
			N => M
		)
		port map (
			ctr    => MemtoReg,
			i_act1 => RD_z,
			i_act0 => S_s,
			o_mux  => Result
		);
	muxp4_1_wd3 : entity work.muxp4
		generic map (
			N => M
		)
		port map (
			ctr    => RegSrc(2),
			i_act1 => PCp4,
			i_act0 => Result,
			o_mux  => WD3_s
		);		

	muxp4_1_pc : entity work.muxp4
		generic map (
			N => M
		)
		port map (
			ctr    => PCSrc,
			i_act1 => Result,
			i_act0 => PCp4,
			o_mux  => PCN_s
		);



end Behavioral;
