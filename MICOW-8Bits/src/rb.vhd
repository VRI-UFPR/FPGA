library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rb_e is
  port (clkDpy_in, clk_in                      : in  std_logic; 
        rbS_in, rbT_in, rbD_in                 : in  std_logic_vector(3 downto 0);
        rbWr_in, rbWrData_in                   : in  std_logic_vector(3 downto 0); 
        rbSOutData_out, rbTOutData_out         : out std_logic_vector(3 downto 0));
        an_out, cat_out                        : out std_logic_vector(7 downto 0)); 
end rb_e;

architecture Behavior of rb_e is
  
  component dpy_e
    port(clk_in                               : in  std_logic;	 
         dpyData_in                           : in  std_logic_vector(15 downto 0);
         an_out, cat_out                      : out std_logic_vector(3 downto 0));
  end component;

  -- 4 registers with 4 bits word 
  type dataArray_t is array(0 to 3)           of std_logic_vector (3 downto 0);

  signal dpyData_s                            : std_logic_vector(15 downto 0);
  
  -- Bank Register initialization
  signal regData_s                            : dataArray_t := ("0000", --0
                                                                "0001", --1
                                                                "0101", --5
                                                                "0101"  --5 
                                                               );
begin

------------------------------- Display ----------------------------------
  
  display: dpy_e  port map (clk_in, dpyData_s, an_in, cat_in);
  
  -- Make a vector, to be displayed, with the values in the registers
  process(regMem_s)
  begin
    dpyData_s   <= regMem_s(3) & regMem_s(2) & regMem_s(1) & regMem_s(0); 
  end process;


------------------------------ Register Bank -----------------------------

  -- Data read from rs and rt
  rbSOutData    <= regMem_s(to_integer(unsigned(rbS_in)));
  rbTOutData    <= regMem_s(to_integer(unsigned(rbT_in)));

  -- Write in the register bank
  process(clk_in, rbWr_in)
  begin

    if rising_edge(clk_in) and rbWr_in = '1' then
      regMem_s(to_integer(unsigned(rbD_in))) <= rbWrData_in;
    end if;
	 
  end process; 	 
 
end Behavior;
