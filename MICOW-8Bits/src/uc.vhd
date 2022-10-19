library IEEE;
use IEEE.std_logic_1164.all;

entity uc_e is
  port (op_in                                  : in  std_logic_vector(1 downto 0);
        rbWr_out, imm_out, bne_out, aluOp_out  : out std_logic;    
        memWr_out, memRd_out                   : out std_logic);
end uc_e;

architecture Behavior of uc_e is

  signal o_s, p_s : std_logic;

begin

  -- Divide the op signal
  o_s        <= op_in(1);
  p_s        <= op_in(0);

  -- Generate the control signals
  rbWr_out   <= ( not p );
  imm_out    <= o_s;
  bne_out    <= ( not o and p );
  aluOp_out  <= ( not o and p );
  memRd_out  <= ( o and not p );
  memWr_out  <= ( o and p );

end Behavior;
