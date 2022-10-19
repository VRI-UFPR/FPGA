library IEEE;
use IEEE.std_logic_1164.all;

entity pc_e is
  port(clk_in                                  : in  std_logic;
       pcCurr_in, pcPlus_in                    : in  std_logic_vector(3 downto 0);
       pcNext_out                              : out std_logic_vector(3 downto 0));
end pc_e;

architecture Behavior of pc_e is

begin

  -- Add if in the rising edge, otherwise, do nothing
  process(clk_in, pcCurr_in, pcPlus_in)
  begin
  
    if rising_edge(clk_in) then
	   pcNext_out <= pcCurr_in + pcSoma_in;
	else
	   pcNext_out <= pcCurr_in;
	end if;
	 
  end process;

end Behavior;
