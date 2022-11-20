library ieee;
use ieee.std_logic_1164.ALL;

entity dpy_e is
  port(clk_in                               : in  std_logic;	 
       dpyData_in                           : in  std_logic_vector(15 downto 0);
       an_out                               : out std_logic_vector(3 downto 0); 
	    cat_out                              : out std_logic_vector(7 downto 0)); 
end dpy_e;

architecture Behavior of dpy_e is

  signal data_s                             : std_logic_vector(3 downto 0); 
  signal div_s                              : natural range 0 to 100000 := 0;
  signal an_s                               : natural range 0 to 4      := 0;

begin

  process(clk_in)
  begin
    
    -- Divide the clk from the FPGA board and update the display
    if rising_edge(clk_in) then
      div_s <= div_s + 1;

      -- Change each display sequentially at every 100.000 clocks from the FPGA board
      if div_s = 100000 then
        div_s <= 0;
        an_s <= an_s + 1;

        if an_s = 4 then
          an_s <= 0;
        end if; --If an_s
			 
      end if; --If div_s
    
    end if; --If clk_in	 
  end process;
 
  -- Select the correct value for each display
  process(an_s, dpyData_in)
  begin
    -- Select witch display to update
    case an_s is
	  when 0      => an_out  <= "1110"; -- Right most display
	                 data_s  <= dpyData_in(3 downto 0);

     when 1      => an_out  <= "1101";
                    data_s  <= dpyData_in(7 downto 4);

	  when 2      => an_out  <= "1011";
                    data_s  <= dpyData_in(11 downto 8);

	  when 3      => an_out  <= "0111"; -- Left most display
	                 data_s  <= dpyData_in(15 downto 12);

     when others => an_out  <= "1111"; -- Turn off all of the displays
                    data_s  <= "0000"; 
    end case;
  end process;
 
  -- Select each segments to turn on and off for each number
  process(data_s)
  begin
    case data_s is
      when "0000" => cat_out <= "11000000"; --  0
      when "0001" => cat_out <= "11111001"; --  1
      when "0010" => cat_out <= "10100100"; --  2
      when "0011" => cat_out <= "10110000"; --  3
      when "0100" => cat_out <= "10011001"; --  4
      when "0101" => cat_out <= "10010010"; --  5
      when "0110" => cat_out <= "10000010"; --  6
      when "0111" => cat_out <= "11111000"; --  7    
            
      when "1111" => cat_out <= "01111001"; -- -1
	   when "1110" => cat_out <= "00100100"; -- -2
	   when "1101" => cat_out <= "00110000"; -- -3
	   when "1100" => cat_out <= "00011001"; -- -4
	   when "1011" => cat_out <= "00010010"; -- -5
	   when "1010" => cat_out <= "00000010"; -- -6
	   when "1001" => cat_out <= "01111000"; -- -7
	   when "1000" => cat_out <= "00000000"; -- -8

      when others => cat_out <= "11111111"; -- Turn off
    end case;
  end process;

end Behavior;
