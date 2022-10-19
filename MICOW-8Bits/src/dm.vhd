library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dm_e is
  port(clk_in, memRead_in, memWrite_in         : in  std_logic;
       memData_in, memAddr_in                  : in  std_logic_vector(3 downto 0);
       memData_out                             : out std_logic_vector(3 downto 0));
end dm_e;

architecture Behavior of dm_e is

  -- Memory with 16 lines and 4 bits word
  type dataArray_t is array (0 to 15)          of std_logic_vector (3 downto 0);

  -- Memory initialization
  signal memData_s                             : dataArray_t := ("0001", --1
                                                                 "0000", --0
                                                                 "0111", --7
                                                                 "0111", --7
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000",
                                                                 "0000"
                                                                );
begin
 
  -- Select the data output: 
  -- when memRd_in is '1' read from the memory, 
  -- otherwise, the data output is 0
  memData_out <= memData_s(to_integer(unsigned(memAddr_in))) when memRd_in = '1' else
                 "0000";

  -- Write the data in the memory
  process(memAddr_in, memData_in, clk_in, memWr_in)
  begin

    if rising_edge(clk_in) and memWr = '1' then
      memData_s(to_integer(unsigned(memAddr_in))) <= memData_in;
    end if;
     
  end process;

end Behavior;
