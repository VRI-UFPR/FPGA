library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity clkDiv_e is
  port(clk_in      : in  std_logic;
       clk_out     : out std_logic);
end clkDiv_e;

architecture Behavior of clkDiv_e is

  signal clkTmp_s  : std_logic := '0';
  signal div_s     : std_logic_vector(27 downto 0):=(others =>'0');

begin

  process(clk_in)
  begin

    if rising_edge(clk_in) then
      div_s <= div_s + x"0000001";

      -- Change clkTmp_s value after 50.000.000 clocks from the FPGA board 
      if div_s = x"2FAF080" then
        div_s <= x"0000000";
        clkTmp_s <= not clkTmp_s;
      end if; -- If div_s
		
	  clk_out <= clkTmp_s;

    end if; --If clk_in
  end process;

end Behavior;
