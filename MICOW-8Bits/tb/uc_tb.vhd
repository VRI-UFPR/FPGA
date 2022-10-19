
library ieee;
use ieee.std_logic_1164.all;
 
ENTITY UnitControl_tb IS
END UnitControl_tb;
 
ARCHITECTURE tb OF UnitControl_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UnitControl
    PORT(
         OP        : IN  std_logic_vector(1 downto 0);
         Zero      : IN  std_logic;
         RegWr     : OUT  std_logic;
         Immediate : OUT  std_logic;
         Beq       : OUT  std_logic;
         MemWr     : OUT  std_logic;
         MemRead   : OUT  std_logic;
         ALUOP     : OUT  std_logic
        );
    END COMPONENT;
    
	type test_record is record
		OP : std_logic_vector (1 downto 0);
		Zero, RegWr, Imm, Beq, MemWr, MemRd, ALUOP : std_logic;
	end record;

	type test_array is array(positive range <>) of test_record;

	constant test_vectors : test_array := (
	-- op, zero, RWr, Imm, Beq, MWr, MRd, ALUOP
	( "00", '0', '1', '0', '0', '0', '0', '0' ),
	( "01", '0', '0', '0', '0', '0', '0', '1' ),
	( "10", '0', '1', '1', '0', '0', '1', '0' ),
	( "11", '0', '0', '1', '0', '1', '0', '0' ), 
	( "00", '1', '1', '0', '0', '0', '0', '0' ),
	( "01", '1', '0', '0', '1', '0', '0', '1' ),
	( "10", '1', '1', '1', '0', '0', '1', '0' ),
	( "11", '1', '0', '1', '0', '1', '0', '0' ) );

   --Inputs
   signal OP   : std_logic_vector(1 downto 0);
   signal Zero : std_logic;

 	--Outputs
   signal RegWr_e, RegWr_r : std_logic;
   signal Imm_e, Imm_r     : std_logic;
   signal Beq_e, Beq_r     : std_logic;
   signal MemWr_e, MemWr_r : std_logic;
   signal MemRd_e, MemRd_r : std_logic;
   signal ALUOP_e, ALUOP_r : std_logic;
 
BEGIN

	-- Componente a ser testado
	U_uc: UnitControl port map(
		OP, Zero, RegWr_r, Imm_r, Beq_r, MemWr_r, MemRd_r, ALUOP_r );
	
	-- Efetua os testes
	U_testValues: process
		variable v : test_record;
	
	begin

		for i in test_vectors'range loop
	
			v       := test_vectors(i); --Valores do teste
			OP      <= v.OP;
			Zero    <= v.Zero;
			RegWr_r <= v.RegWr;
			Imm_r   <= v.Imm;
			Beq_r   <= v.Beq;
			MemWr_r <= v.MemWr;
			MemRd_r <= v.MemRd;
			ALUOP_r <= v.ALUOP;

			wait for 200ps; --Duracao do passo de simulacao
		
			assert ( (RegWr_e = RegWr_r) and (Imm_e = Imm_r) and 
						(Beq_e = Beq_r) and (MemWr_e = MemWr_r) and
						(MemRd_e = MemRd_r) and (ALUOP_e = ALUOP_r) )
			report LF & " algo deu errado"
			severity error;

		end loop;
		
		wait; --Encerra a simulacao

	end process U_testValues;

END tb;
