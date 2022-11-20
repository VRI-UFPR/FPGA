library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rb_e is
  port (clkDpy_in, clk_in, rbWr_in             : in  std_logic; 
        rbS_in, rbT_in, rbD_in                 : in  std_logic_vector(1 downto 0);
		rbWrData_in                            : in  std_logic_vector(3 downto 0);
        rbSOutData_out, rbTOutData_out         : out std_logic_vector(3 downto 0);
        an_out                                 : out std_logic_vector(3 downto 0); 
	    cat_out                                : out std_logic_vector(7 downto 0)); 
end rb_e;

architecture Behavior of rb_e is
  
  component dpy_e
    port(clk_in                                : in  std_logic;	 
         dpyData_in                            : in  std_logic_vector(15 downto 0);
         an_out                                : out std_logic_vector(3 downto 0); 
		 cat_out                               : out std_logic_vector(7 downto 0)); 
  end component;

  -- 4 registers with 4 bits word 
  type dataArray_t is array(0 to 3)            of std_logic_vector (3 downto 0);

  signal dpyData_s                             : std_logic_vector(15 downto 0);
  
  -- Bank Register initialization
  signal rbData_s                              : dataArray_t := ("0000", --0
                                                                 "0001", --1
                                                                 "0101", --5
                                                                 "0101"  --5 
                                                                 );
begin

------------------------------- Display ----------------------------------
  
  display: dpy_e  port map (clkDpy_in, dpyData_s, an_out, cat_out);
  
  -- Make a vector, to be displayed, with the values in the registers
  process(rbData_s)
  begin
    dpyData_s     <= rbData_s(3) & rbData_s(2) & rbData_s(1) & rbData_s(0); 
  end process;


------------------------------ Register Bank -----------------------------

  -- Data read from rs and rt
  rbSOutData_out  <= rbData_s(to_integer(unsigned(rbS_in)));
  rbTOutData_out  <= rbData_s(to_integer(unsigned(rbT_in)));

  -- Write in the register bank
  process(clk_in, rbWr_in)
  begin

    if rising_edge(clk_in) and rbWr_in = '1' then
      rbData_s(to_integer(unsigned(rbD_in))) <= rbWrData_in;
    end if;
	 
  end process; 	 
 
end Behavior;
