library ieee;
use ieee.std_logic_1164.all;

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
  rbWr_out   <= not p_s;
  imm_out    <= o_s;
  bne_out    <= not o_s and p_s;
  aluOp_out  <= not o_s and p_s;
  memRd_out  <= o_s and not p_s;
  memWr_out  <= o_s and p_s;

end Behavior;
