library IEEE;
use IEEE.std_logic_1164.ALL;

entity alu_e is
  port(aluOp_in                                : in  std_logic;
       aluFirst_in, aluSecond_in               : in  std_logic_vector(3 downto 0);
       zero_out                                : out std_logic;
       result_out                              : out std_logic_vector(3 downto 0));
end alu_e;

architecture Behavior of alu_e is

  signal result_s                              : std_logic_vector(3 downto 0);

begin
  
  -- Select between add or sub, according to aluOp 
  result_s   <= aluFirst_in + aluSecond_in  when aluOp_in = '0' else
                aluFirst_in - aluSecond_in;

  -- If the result is 0, activate the zero signal
  zero_out   <= '1'  when result_s = 0 else
                '0';

  result_out <= result_s;
  
end Behavior;
